# Sources -----------------------------------------------------------------



# Configure git -----------------------------------------------------------

# git --version
# git config --global user.name "Jonathan Kitt"
# git config --global user.email jonathan.kitt@inrae.fr
# git config --global --list

# Getting help ------------------------------------------------------------

# git help config
# git config --help

# Create a folder ---------------------------------------------------------

# mkdir tuto_git_local
# cd tuto_git_local
# ls

# Add files in dir --------------------------------------------------------

# touch file1.txt
# touch .project

# Initialise a local git repo ---------------------------------------------

# pwd
# git init
# ls
# ls -la

# to stop tracking our directory: rm -rf .git

# First commit ------------------------------------------------------------

# git status
# echo .project > .gitignore
# ls -la
# git status

# git add -A
# git add .
# git add .gitignore
# git add file1.txt
# git add .gitignore file1.txt

# to remove file from staging area: git reset
# git reset file1.txt

# git commit -m "initial commit"

# git log

# Apply changes  ----------------------------------------------------------

# echo hello > file1.txt
# cat file1.txt

# show the changes made to the code: git diff
# git status

# git add -A
# git status
# git commit -m "add text in file1.txt"

# Create a branch ---------------------------------------------------------

# git branch file2
# git branch
# git checkout file2
# git branch
