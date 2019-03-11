#Notification API Wrapper for Python

from onesignal import OneSignal, SegmentNotification, FilterNotification
import keyconfig

client = OneSignal(keyconfig.app_id, keyconfig.restAPI_id)

def PushToAll(message):
    nf_to_all = SegmentNotification(
        contents= {"en": message},
        included_segments=SegmentNotification.ALL
    )
    client.send(nf_to_all)

def PushToUser(appID, username, message):
    nf_to_some = FilterNotification(
        contents={"en": username + message},
        Filter.Tag("appID", "=", appID)
    )
    client.send(nf_to_some)
