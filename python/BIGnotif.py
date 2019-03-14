#Notification API Wrapper for Python

from onesignal import OneSignal, SegmentNotification, FilterNotification, Filter

client = OneSignal("b93dcd48-6999-4353-8c4d-4a81b063f8c4", "RestAPI Key Here")

def PushToAll(message):
    nf_to_all = SegmentNotification(
        contents= {"en": message},
        included_segments=SegmentNotification.ALL
    )
    client.send(nf_to_all)

def PushToUser(appID, username, message):
    nf_to_some = FilterNotification(
        contents={"en": username + message},
        filters=[Filter.Tag("appID", "=", appID),]
    )
    client.send(nf_to_some)