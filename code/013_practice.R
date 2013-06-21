

# ran for code check and consistency
source("code/1_hello.R")



rep("See you next week!", 6)



# Check the working directory.
if(!grepl("IDA$", getwd()))
  warning("Not sure whether the working directory is really ",
          "the IDA folder...", "\nCarrying on anyway...")
# Create folders if necessary.
if(!file.exists("code")) dir.create("code")
if(!file.exists("data")) dir.create("data")



# Match filenames ending in .R in the working directory.
regex <- list.files(".", ".R$")
# This variable will be 0 (FALSE) if nothing is matched.
clean <- length(regex)
# Move .R scripts to code/ subfolder.
if(clean) {
  message("Moving files to code folder:\n", paste(scripts, collapse = "\n"))
  file.copy(scripts, "code")
  file.remove(scripts)
} else {
  message("No R script was found lying around.")
}


