import Qt 4.7
import com.nokia.symbian 1.1

Page {
    id: wrapper
    tools: commonTools
    orientationLock: PageOrientation.LockPortrait

    property variant model
    property bool updateContent: false

    Component.onCompleted: {
        main.log("parkings page is created")
        if(main.pageStack.currentPage === wrapper){
            if (!model)
                car2goManager.getParkings()
        }
    }

    onStatusChanged: {
        if(wrapper.status == PageStatus.Activating && wrapper.updateContent){
            wrapper.updateContent = false
            car2goManager.getParkings()
        }
    }

    Connections{
        target:car2goManager

        onParkingspotsUpdated:{
            wrapper.model = parkingsModel
            parkingSpotsView.model = wrapper.model
        }
    }

    //Delay network request till page is activated
    Connections{
        target:car2goSettings
        onCityChanged:{ wrapper.updateContent = true }
    }


    Rectangle{
        anchors.fill: parent
        color: globalSettings.list_item_content_normal_color

        ListView{
            id: parkingSpotsView
            anchors.topMargin: globalSettings.headerPortraiHeight
            anchors.fill: parent
            delegate: ParkingSpotsDelegate{}
            cacheBuffer: parkingSpotsView.height
            clip: true
        }

        ScrollDecorator {
            flickableItem: parkingSpotsView
        }
    }

    BusyIndicator {
        id: indicator
        anchors.centerIn: parent
        width: 100
        height: 100
        running: !model && (wrapper.status == PageStatus.Active)
        opacity: running ? 1:0
        Behavior on opacity { NumberAnimation { duration: 500; } }
    }

    PageHeader {
        id: header
        title: "Parkings"
        onMapIconClicked:  {
            main.playEffect()
            pageStack.push(main.openFile("ParkingSpotsMapPage.qml"))
        }
        onSettingsIconClicked: {
            main.playEffect()
            pageStack.push( main.openFile("SettingsPage.qml"))
        }
    }

}
