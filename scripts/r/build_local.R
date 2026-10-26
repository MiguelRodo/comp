# Local original-projr builds: preserve configured publication destinations.
# Route nested/all-format documents through native output/docs collection;
# the legacy docs collector only scans root-level source files.
# projr 0.5.2-10 treats even `github: false` as an active remote during checks.
build_sta2005s_local <- function(bump_component = "minor", msg = "",
                                args_engine = list(), profile = "localonly") {
  stopifnot(requireNamespace("projr", quietly = TRUE),
            requireNamespace("yaml", quietly = TRUE))
  defaults <- list(
    output_format = "all", as_job = FALSE,
    metadata = list("latex-auto-install" = FALSE, "pdf-engine" = "xelatex"),
    quarto_args = quote(c("--output-dir", projr::projr_path_get_dir(
      "output", "docs", format = "absolute", safe = TRUE, create = FALSE)))
  )
  args_engine <- utils::modifyList(defaults, args_engine)
  config_file <- normalizePath("_projr.yml", mustWork = TRUE)
  original <- yaml::read_yaml(config_file)
  backup_dir <- file.path(dirname(config_file), "_tmp", "local-build")
  dir.create(backup_dir, recursive = TRUE, showWarnings = FALSE)
  backup_file <- tempfile("config-original-", tmpdir = backup_dir, fileext = ".yml")
  stopifnot(file.copy(config_file, backup_file))
  old_profile <- Sys.getenv("PROJR_PROFILE", unset = NA_character_)
  Sys.setenv(PROJR_PROFILE = profile)
  on.exit({
    if (is.na(old_profile)) Sys.unsetenv("PROJR_PROFILE") else
      Sys.setenv(PROJR_PROFILE = old_profile)
  }, add = TRUE)
  on.exit({
    current <- yaml::read_yaml(config_file)
    for (key in c("github", "local")) {
      saved <- original$build[[key]]
      if (!is.null(current$build[[key]]) &&
          !identical(current$build[[key]], saved)) {
        warning("Destination changed during build; preserved current ", key,
                ". Original configuration: ", backup_file)
      } else {
        current$build[[key]] <- saved
      }
    }
    yaml::write_yaml(current, config_file)
  }, add = TRUE)
  local <- original
  local$build$github <- NULL
  local$build$local <- NULL
  yaml::write_yaml(local, config_file)
  ns <- asNamespace("projr")
  stopifnot(length(get(".remote_ls", ns)()) == 0L,
            identical(get(".yml_git_get_commit", ns)(NULL), FALSE),
            identical(get(".yml_git_get_push", ns)(NULL), FALSE),
            length(get(".dest_send_get_type", ns)(FALSE, FALSE)) == 0L)
  check <- projr::projr_build_check_packages(profile)
  if (!isTRUE(check$available)) stop(check$message, call. = FALSE)
  projr::projr_build(bump_component = bump_component, msg = msg,
                    args_engine = args_engine, profile = profile,
                    archive_github = FALSE, archive_local = FALSE,
                    clear_output = "never")
}
