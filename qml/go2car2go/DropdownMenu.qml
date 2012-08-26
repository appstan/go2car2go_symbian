import QtQuick 1.1
import com.nokia.symbian 1.1


CommonDialog{
    id: dropdownMenu
    titleText: ' Supported car2go cities '
    property int menuTopY:100
    property int menuHeight:600
    platformInverted: true

    visualParent:preferencesPage

    property alias model: locations.model

    function triggered() {
        if(status == DialogStatus.Open) {
            close();
        } else {
            if(true){
                console.log(locations.model.count)
                car2goManager.getLocations()
            }
            open();
        }
    }

    content: Item {
        width: parent.width
        height: 450
        anchors.margins: platformStyle.paddingMedium
        ListView {
            id: locations
            anchors.fill: parent
            clip: true
            model:locationsModel
            delegate:LocationsDelegate{}

        }
        ScrollDecorator {
            flickableItem: locations
        }

    }

}

