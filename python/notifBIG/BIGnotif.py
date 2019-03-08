#Notification API Wrapper for Python

from onesignal import OneSignal, SegmentNotification, DeviceNotification
import keyconfig

client = OneSignal(keyconfig.app_id, keyconfig.restAPI_id)

def PushToAll(message):
    nf_to_all = SegmentNotification(
        contents= {"en": message},
        included_segments=SegmentNotification.ALL
    )
    client.send(nf_to_all)

def PushToUser(appID, message):
    nf_to_some = DeviceNotification(
        contents={"en": message},
        include_ios_tokens=appID
    )
    client.send(nf_to_some)
