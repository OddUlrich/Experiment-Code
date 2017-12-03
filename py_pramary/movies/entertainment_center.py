import media
import fresh_tomatoes

toy_story = media.Movie("Toy Story",
                        "A story of a boy and his toys that come to life",
                        "",
                        "")

avatar = media.Movie("Avatar",
                     "A marine on an alien planet",
                     "",
                     "")

code_lyoko = media.Movie("Code Lyoko",
                         "A group of teenagers who travel to the virtual world of Lyoko to battle against a malignant artificial intelligence named XANA who threatens Earth",
                         "http://cn.bing.com/images/search?view=detailV2&ccid=FKLWEbHA&id=F680D44794761FCFC66038536D6C76924E32E591&thid=OIP.FKLWEbHAdXTJEgrOwFuxhgEsDh&q=code+lyoko&simid=608018627505160995&selectedIndex=6&ajaxhist=0",
                         "https://www.bilibili.com/video/av2671604/?from=search&seid=10450376980346952107")


movies = [toy_story, avatar, code_lyoko]
#fresh_tomatoes.open_movies_page(movies)

#print media.Movie.VALID_RATINGS
print media.Movie.__doc__
print media.Movie.__name__
print media.Movie.__module__
