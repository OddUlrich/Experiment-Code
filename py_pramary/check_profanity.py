import urllib

def read_text(filename):
    quotes = open(filename)
    content_of_file = quotes.read()
    print content_of_file
    quotes.close()
    check_profanity(content_of_file)

def check_profanity(text_to_check):
    connection = urllib.urlopen("http://www.wdylike.appspot.com/?q="+text_to_check)
    output = connection.read()
    # print output
    connection.close()

    if "true" in output:
        print "No profanity!"
    elif "false" in output:
        print "Alert!!!"
    else:
        print "ERROR"


    
read_text(filename)
