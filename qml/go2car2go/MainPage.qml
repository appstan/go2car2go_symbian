import Qt 4.7
import com.nokia.symbian 1.1

Page {
    tools: commonTools
     property variant model

    Label {
        id: label
        anchors.centerIn: parent
        text: qsTr("Hello world!")
        visible: false
    }

    Button{
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: label.bottom
            topMargin: 10
        }
        text: qsTr("Click here!")
        onClicked: label.visible = true
    }

    BusyIndicator {
        id: indicator
        anchors.centerIn: parent
        width: 100
        height: 100
        running: !model
        opacity: running ? 1:0
        Behavior on opacity { NumberAnimation { duration: 500; } }
    }

    PageHeader {
        id: header
        title: "Go2Car2Go"
    }

}
