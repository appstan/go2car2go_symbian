import QtQuick 1.1
import com.nokia.symbian 1.1

Page{
    id:preferencesPage
    tools: settingsTools
    signal cityChanged
    orientationLock: PageOrientation.LockPortrait

    property string name: "settings"
    property string unit: ""
    property string location: ""

    function updateCity(){
        if(locationItem.text !== car2goSettings.city()){
            locationItem.text = car2goSettings.city()
        }
    }
    function savePreferenceChanges(){
        if(locationItem.text !== car2goSettings.city()){
            car2goSettings.setCity(locationItem.text)
        }
        car2goSettings.writeSettings()
        main.unitMetric = car2goSettings.unitSystem() == "metric" ? true : false
    }

    // Show current city
    Component.onCompleted: {
        updateCity()
        main.log("preferences page is completed")
    }

    Connections{
        target:car2goSettings
        onCityChanged:updateCity()
    }
    Rectangle{
        anchors.fill: parent
        color: globalSettings.list_item_content_normal_color

        Rectangle{
            id: unit

            anchors.top: header.bottom
            anchors.topMargin: 40
            x: 10
            width: 340

            radius:12
            color: "#B5B0B1"
            border.color: "#b6b7b8"
            height:  120
            anchors.margins: 10

            Text{
                text:"Unit"
                font.family:"Nokia Pure Text Light"
                font.weight: Font.Light
                color: globalSettings.colorWhite
                font.pixelSize:globalSettings.largeFontSize
                x: 30
                anchors.top: parent.top
            }

            Rectangle {
                radius:12
                width: 326
                anchors.leftMargin: 2
                anchors.rightMargin: 2
                anchors.bottomMargin: 2
                anchors.topMargin: 40
                height:  80

                anchors.fill: parent
                border.width: 1
                border.color: "#b6b7b8"
                color: globalSettings.list_item_content_normal_color


                ButtonRow{
                    id:unitButtonRow
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -1
                    anchors.margins: 5
                    width: 290
                    x: 20

                    checkedButton: car2goSettings.unitSystem() == "metric" ? b1 : b2
                    Button {
                        id: b1
                        text: "km"
                        width: 130
                        onClicked: {car2goSettings.setUnitSystem("metric")}
                    }

                    Button {
                        id: b2
                        text: "miles"
                        width: 130
                        onClicked: {car2goSettings.setUnitSystem("imperial")}

                    }

                }

            }
        }

        Rectangle{
            id: location

            anchors.top: unit.bottom
            anchors.topMargin: 40
            x: 10
            width: 340

            radius:12
            color: "#B5B0B1"
            border.color: "#b6b7b8"
            height:  100
            anchors.margins: 10

            Text{
                text:"Location"
                font.family:"Nokia Pure Text Light"
                font.weight: Font.Light
                color: globalSettings.colorWhite
                font.pixelSize:globalSettings.largeFontSize
                x: 30
                anchors.top: parent.top
            }

            Rectangle {
                radius:12
                width: 296
                anchors.leftMargin: 2
                anchors.rightMargin: 2
                anchors.bottomMargin: 2
                anchors.topMargin: 40
                height:  60

                anchors.fill: parent
                border.width: 1
                border.color: "#b6b7b8"
                color: globalSettings.list_item_content_normal_color

                // selected city
                Text {
                    id: locationItem
                    anchors.topMargin: globalSettings.hugeMargin
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 32
                    font.pixelSize:globalSettings.bigFontSize
                    font.family: globalSettings.defaultFontFamily
                    font.weight: Font.Light
                    color: globalSettings.colorBlack
                    elide: Text.ElideRight
                }

                Image {
                    anchors.topMargin: globalSettings.hugeMargin
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 32
                    width: sourceSize.width
                    height: sourceSize.height
                    source: "qrc:///images/dropdown_list_arrow.svg"
                }


                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        main.playEffect()
                        dropdownMenu.triggered()
                    }
                }

                DropdownMenu {
                    id: dropdownMenu
                }

                Behavior on y {
                    NumberAnimation { duration: 200; }
                }

            }
        }

        BusyIndicator {
            id: indicator
            anchors.centerIn: parent
            width: 100
            height: 100
            running: !dropdownMenu.model || dropdownMenu.model.count < 0
            opacity: running ? 1:0
            Behavior on opacity { NumberAnimation { duration: 500; } }
        }

        PageHeader {
            id: header
            title: "Preferences"
            icons: false
        }

        ToolBarLayout {
            id: settingsTools
            ToolButton {
                iconSource: "toolbar-back"
                onClicked: { savePreferenceChanges(); pageStack.pop()}
            }

        }

    }


}
