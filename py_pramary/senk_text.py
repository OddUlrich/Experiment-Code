from twilio.rest import Client

# Your Account SID from twilio.com/console
account_sid = "ACfd1b700d7935640136e131ca7da25718"
# Your Auth Token from twilio.com/console
auth_token  = "ee13134d405a9c9f62dd853341791fd3"

client = Client(account_sid, auth_token)

message = client.messages.create(
    to="+13419668891", 
    from_="+18312747085",
    body="Hello! Glad to see you, bro!")

print(message.sid)
