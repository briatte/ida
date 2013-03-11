

if(!grepl("IDA$", getwd()))
  warning("Not sure whether the working directory is really ",
          "the IDA folder...", "\nCarrying on anyway...")
if(!file.exists("code")) dir.create("code")
if(!file.exists("data")) dir.create("data")
if(length(scripts <- list.files(".", ".R$"))) {
  message("Moving files to code folder:\n", paste(scripts, collapse = "\n"))
  file.copy(scripts, "code")
  file.remove(scripts)
}



rep("See you next week!", 10)


