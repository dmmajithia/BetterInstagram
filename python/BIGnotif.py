#Notification API Wrapper for Python

from onesignal import OneSignal, SegmentNotification, FilterNotification, Filter

client = OneSignal("b93dcd48-6999-4353-8c4d-4a81b063f8c4", "NDgwMTFmZmUtNmVkYi00YzFhLTg0ZWUtZmMyYjU2ZGU3M2U3")

# def PushToAll(message):
#     nf_to_all = SegmentNotification(
#         contents= {"en": message},
#         included_segments=SegmentNotification.ALL
#     )
#     client.send(nf_to_all)

def PushToUser(appID, username, message):
    try:
        nf_to_some = FilterNotification(
            contents={"en": username + message},
            filters=[Filter.Tag("appID", "=", appID),]
        )
        client.send(nf_to_some)
        return True
    except:
        return False
