import Qt 4.7
import QtMobility.systeminfo 1.2
import QtMobility.feedback 1.1
import QtMobility.location 1.2
import com.nokia.symbian 1.1

PageStackWindow {
    id: main

    width: globalSettings.width
    height: globalSettings.height

    initialPage: vehiclesPage

    property bool loggingEnabled: true
    property bool unitMetric: car2goSettings.unitSystem() == "metric" ? true : false

    property bool hibernate: !Qt.application.active
    property variant user: userStatus

    signal cityChanged
    signal itemClicked()

    property string itemName: ""
    property string itemInterior: ""
    property string itemExterior: ""
    property string itemFuel: ""
    property string itemAddress: ""
    property string itemDistance: ""
    property string itemLatitude: ""
    property string itemLongitude: ""

    onItemClicked:  {
        itemText1.text = itemName
        itemText2.text = itemInterior
        itemText3.text = itemExterior
        itemText4.text = itemFuel
        itemText5.text = itemAddress
        itemText6.text = globalSettings.locateDistance(itemDistance, main.unitMetric)

        myMenu.open()
    }

    onHibernateChanged: {
        if (hibernate){
        }
        else{
        }
    }

    DeviceInfo {
        id: devinfo
    }

    Settings{
        id:globalSettings
    }

    function playEffect(){
        actionEffect.play()
    }

    HapticsEffect {
         id: actionEffect
         attackIntensity: 0.0
         attackTime: 200
         intensity: 1.0
         duration: 100
         fadeTime: 200
         fadeIntensity: 0.0
         running: false
         function play(){
             running = true
             actionTimer.restart()
         }
     }

    Timer{
        id: actionTimer
        interval: 300
        onTriggered: {
            actionEffect.running = false
        }
    }

    function setMyLocation (latitude, longitude , direction)  {
        userCurrentLocation.latitude = latitude;
        userCurrentLocation.longitude = longitude;
     }

    Coordinate {
        id: userCurrentLocation
    }

    Connections{
        target:car2goManager
        onPositionChanged: {
            setMyLocation(latitude, longitude , direction);
        }

    }

    UserStatusContainer{
        id: userStatus
        currentLatitude: userCurrentLocation.latitude ? userCurrentLocation.latitude : 48.421711 // CAR2GO HQ Ulm
        currentLongitude: userCurrentLocation.longitude ? userCurrentLocation.longitude : 9.941962
    }

    VehiclesPage {
        id: vehiclesPage
    }

    GasStationsPage {
        id: gasstationsPage
    }

    ParkingSpotsPage {
        id: parkingsPage
    }

    ToolBarLayout {
        id: commonTools
        visible: true


        ToolButton {
            iconSource: "toolbar-back"
            onClicked: Qt.quit()
        }

        ToolButton {
            id:toolbarItemVehicle
            iconSource: "qrc:///images/vehicle.png"
            onClicked: {
                if (pageStack.currentPage !== vehiclesPage){
                    pageStack.replace(vehiclesPage)
                }
            }
        }
        ToolButton {
            id:toolbarItemParking
            iconSource:"qrc:///images/parking.png"
            onClicked: {
                if (pageStack.currentPage !== parkingsPage){
                    pageStack.replace(parkingsPage)
                    if (!parkingsPage.model)
                        car2goManager.getParkings()

                }
            }
        }
        ToolButton {
            id:toolbarItemGasstation
            iconSource:"qrc:///images/station.png"
            onClicked: {
                if (pageStack.currentPage !== gasstationsPage){
                    pageStack.replace(gasstationsPage)
                    if (!gasstationsPage.model)
                        car2goManager.getGasStations()

                }
            }
        }
        ToolButton {
            id:toolbarItemBooking
            iconSource: "qrc:///images/reserve.png"
            onClicked:  {
                main.playEffect()
                pageStack.push( main.openFile("BookingsPage.qml"))
            }
        }
    }


    Menu {
        id: myMenu
        visualParent: pageStack
        platformInverted: true

        onStatusChanged: {
            if (myMenu.status == DialogStatus.Closed){
                itemName = ""
                itemInterior = ""
                itemExterior = ""
                itemFuel = ""
                itemAddress = ""
                itemDistance = ""
                itemLatitude = ""
                itemLongitude = ""
            }
        }

        MenuLayout{
            Item{width:parent.width; height: 4}
            Text{
                id: itemText1
                height:itemText1.text == "" ? 0 : globalSettings.bigFontSize
                color: globalSettings.colorOrange
                font.family: globalSettings.defaultFontFamily
                font.pixelSize: globalSettings.bigFontSize
                x: 15
//                anchors {left: parent.left; top: parent.top; margins:globalSettings.largeMargin}
            }
            Item{width:parent.width; height: 4}
            //INTERIOR
            Text{
                id: itemText2
                width: parent.width
                height:itemText2.text == "" ? 0 : globalSettings.bigFontSize
                color: globalSettings.colorBlack
                elide: Text.ElideRight
                wrapMode: Text.Wrap
                font.family:globalSettings.defaultFontFamily
                font.pixelSize: globalSettings.normalFontSize
                x: 15
//                anchors {left: parent.left; top: itemText1.bottom; margins:globalSettings.smallMargin; leftMargin: globalSettings.largeMargin}
            }
            //EXTERIOR
            Text{
                id: itemText3
                width: parent.width
                height:itemText3.text == "" ? 0 : globalSettings.bigFontSize
                elide: Text.ElideRight
                wrapMode: Text.Wrap
                font.family:globalSettings.defaultFontFamily
                font.pixelSize: globalSettings.normalFontSize
                x: 15
 //               anchors {left: parent.left; top: itemText2.bottom; margins:globalSettings.smallMargin; leftMargin: globalSettings.largeMargin}
            }
            //FUEL
            Text{
                id: itemText4
                width: parent.width
                height:itemText4.text == "" ? 0 : globalSettings.bigFontSize
                color: globalSettings.colorBlack
                elide: Text.ElideRight
                wrapMode: Text.Wrap
                font.family:globalSettings.defaultFontFamily
                font.pixelSize: globalSettings.normalFontSize
                x: 15
 //               anchors {left: parent.left; top: itemText3.bottom; margins:globalSettings.smallMargin; leftMargin: globalSettings.largeMargin}
            }

            //ADDRESS
            Text{
                id: itemText5
                width: parent.width - 10
                color: globalSettings.colorBlack
                elide: Text.ElideRight
                wrapMode: Text.NoWrap
                font.family:globalSettings.defaultFontFamily
                font.pixelSize: globalSettings.mediumFontSize
                x: 14
 //               anchors.bottomMargin: globalSettings.extraLargeMargin
//                anchors {left: parent.left; top: itemText4.bottom; margins:globalSettings.smallMargin; leftMargin: globalSettings.largeMargin}
            }
            //DISTANCE
            Text{
                id: itemText6
                color: globalSettings.colorOrange
                elide: Text.ElideRight
                font.family :globalSettings.defaultFontFamily
                font.pixelSize: 18
                x: 15
 //               anchors { top: itemText4.bottom;  right:parent.right; margins:globalSettings.smallMargin; rightMargin: globalSettings.largeMargin}
            }
            Item{width:parent.width; height: 4}

            HorizontalDivider { width: parent.width ; margin: 5}

            Item{width:parent.width; height: 15}

            Timer{
                id: actionDelay
                interval: 5000
                running: false
                repeat: false
            }

            Button{
                text: qsTr("Route")
                platformInverted: true
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 10
                height: 50
                onClicked: {
                    main.playEffect()
                    var geoLocation = "geo:"+ itemLatitude + "," + itemLongitude
                    if(Qt.openUrlExternally(geoLocation)){
                        main.log("launching Nokia Maps was successful")
                    }
                    actionDelay.start()
                }
            }

            Item{width:parent.width; height: 7}

//            Button{
//                text: qsTr("Book")
//                platformInverted: true
//                anchors.horizontalCenter: parent.horizontalCenter
//                width: parent.width - 10
//                height: 50
//            }

//            Item{width:parent.width; height: 4}

            Button{
                text: qsTr("Cancel")
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 10
                height: 50
            }
            Item{width:parent.width; height: 4}

        }
    }

    function currentMainPage() {
        return pageStack.currentPage.name
    }

    function log(aData){
        if (loggingEnabled){
            var date = new Date()
            console.log(date + ":   " + aData)
        }
    }

    function openFile(file) {
        var component = Qt.createComponent(file)
        if (component.status != Component.Ready){
            main.log("Error loading component:" + component.errorString());
            return null;
        }
        return component
    }

    function addPage(file) {
        var component = Qt.createComponent(file)

        if (component.status === Component.Ready) {
            pageStack.push(component);
        } else {
            main.log("Error loading component:", component.errorString());
        }
    }

    function replacePage(file) {
        var component = Qt.createComponent(file)

        if (component.status === Component.Ready) {
            pageStack.replace(component);
        } else {
            main.log("Error loading component:", component.errorString());
        }
    }

}
