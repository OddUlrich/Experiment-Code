import os

def rename_files():
    # get file names from a folder
    file_list = os.listdir(r"C:\Python27\practice\secret")

    saved_path = os.getcwd()
    print("Current Working Directory is :" + saved_path)
    os.chdir(r"C:\Python27\practice\secret")
    
    # rename each file
    for file_name in file_list:
        print("Old file_name is: " + file_name)
        print("New file_name is: " + file_name.translate(None, "0123456789"))
        os.rename(file_name, file_name.translate(None, "01234556789"))

rename_files()
