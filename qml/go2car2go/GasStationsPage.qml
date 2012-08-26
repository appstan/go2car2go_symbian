import Qt 4.7
import com.nokia.symbian 1.1

Page {
    id: wrapper
    tools: commonTools
    orientationLock: PageOrientation.LockPortrait

    property variant model
    property bool updateContent: false

    Component.onCompleted: {
        main.log("gas stations page is created")
    }

    onStatusChanged: {
        if(wrapper.status == PageStatus.Activating && wrapper.updateContent){
            wrapper.updateContent = false
            car2goManager.getGasStations()
        }
    }

    Connections{
        target:car2goManager

        onGasstationsUpdated:{
            wrapper.model = gasstationsModel
            gasStationsView.model = wrapper.model
            textArea.opacity = model && gasstationsModel.count > 0 ? 0:1
        }
        onErrorOccured:{
            textArea.text = message
        }
    }
    // Delay network request till page is activated
    Connections{
        target:car2goSettings
        onCityChanged: { wrapper.updateContent = true }
    }

    Rectangle{
        anchors.fill: parent
        color: globalSettings.list_item_content_normal_color

        ListView{
            id: gasStationsView
            anchors.fill: parent
            anchors.topMargin: globalSettings.headerPortraiHeight
            delegate: GasStationsDelegate{}
            cacheBuffer: gasStationsView.height
            clip: true
        }

        ScrollDecorator {
            flickableItem: gasStationsView
        }

        // placeholder for any kind of error messages
        Text{
            id: textArea
            opacity: indicator.running ||model && gasstationsModel.count > 0 ? 0:1
            anchors.topMargin: globalSettings.headerPortraiHeight
            height: opacity == 1? 600:0
            width: parent.width - 30
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: globalSettings.colorGray
            font.pixelSize: globalSettings.megaLargeFontSize
            font.family: globalSettings.defaultFontFamily
            font.weight: Font.DemiBold
            text: "No gas stations"
            wrapMode: Text.Wrap
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
        title: "Gas Stations"
        onMapIconClicked:  {
            main.playEffect()
            pageStack.push(main.openFile("GasStationsMapPage.qml"))
        }
        onSettingsIconClicked: {
            main.playEffect()
            pageStack.push( main.openFile("SettingsPage.qml"))
        }
    }

}
