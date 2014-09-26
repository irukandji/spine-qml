import QtQuick 2.1
import QtQuick.Window 2.1
import Spine 1.0
import QtQuick.Controls 1.2

Window {
    visible: true
    width: 800; height: 480;

    Rectangle{
        anchors.fill: parent
        color: Qt.rgba(0.5, 0.5, 0.5, 1.0)
    }

    SkeletonAnimation{
        id: skeleton
        anchors.bottom: row.top
        anchors.horizontalCenter: parent.horizontalCenter

        skeletonDataFile: "resource/spineboy.json"
        atlasFile: "resource/spineboy.atlas"
        scale: 0.6

        onStart:{
            //console.log("skeleton onStart trackIndex: "+ trackIndex);
        }
        onEnd:{
            //console.log("skeleton onEnd trackIndex: "+ trackIndex);
        }
        onComplete:{
            //console.log("skeleton onComplete trackIndex: "+ trackIndex + ", loopCount:" +loopCount);
        }
        onEvent:
            console.log("skeleton onEvent trackIndex: "+ trackIndex + ", name:" +event.data.name + ", stringValue:" +event.stringValue);

        states: [
            State {
                name: "raptor"
                StateChangeScript{
                    id: raptorScript
                    script: setupRaptorSkeleton()
                }
            },
            State {
                name: "spineboy"
                StateChangeScript{
                    id: spineboyScript
                    script: setupSpineboySkeleton()
                }
            },
            State{
                name: "goblins"
                StateChangeScript{
                    id: goblinsScript
                    script: setupGoblinsSkeleton()
                }
            }
        ]

        transitions: [
            Transition {
                to: "raptor"
                ScriptAction { scriptName: "raptorScript" }
            },
            Transition {
                to: "spineboy"
                ScriptAction { scriptName: "spineboyScript" }
            },
            Transition {
                to: "goblins"
                ScriptAction { scriptName: "goblinsScript" }
            }
        ]

        state: "raptor"
    }

    function setupRaptorSkeleton(){
        skeleton.skeletonDataFile = "resource/raptor.json"
        skeleton.atlasFile = "resource/raptor.atlas"
        skeleton.scale = 0.4
        skeleton.debugTracer = false
        skeleton.skin ="default"

        skeleton.setAnimation(0, "walk", true)
        skeleton.setAnimation(1, "empty", false)
        skeleton.addAnimation(1, "gungrab", false, 2)
    }

    function setupSpineboySkeleton(){
        skeleton.skeletonDataFile = "resource/spineboy.json"
        skeleton.atlasFile = "resource/spineboy.atlas"
        skeleton.scale = 0.6
        skeleton.debugTracer = false
        skeleton.skin ="default"

        skeleton.setMix("walk", "jump", 0.2)
        skeleton.setMix("jump", "walk", 0.4)
        skeleton.setAnimation(0, "idle", true)
    }

    function setupGoblinsSkeleton(){
        skeleton.atlasFile = "resource/goblins-ffd.atlas"
        skeleton.skeletonDataFile = "resource/goblins-ffd.json"
        skeleton.scale =  1.0
        skeleton.debugTracer =  false
        skeleton.skin = "goblin"
        skeleton.setAnimation(0, "walk", true)
        skeleton.setToSetupPose()
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (skeleton.state === "raptor"){
                skeleton.debugBones = !skeleton.debugBones
            }
            else if (skeleton.state === "spineboy"){
                skeleton.setAnimation(0, "jump", false)
                skeleton.addAnimation(0, "walk", true, 0)
            }
            else{
                skeleton.skin = skeleton.skin === "goblin"? "goblingirl" : "goblin"
            }
        }
    }

    Row{
        id: row
        anchors.bottom: txtRect.top; anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 4;
        spacing: 10
        Button{
            id: button
            text:"Raptor"
            onClicked: skeleton.state = "raptor"
        }
        Button{
            text:"Spineboy"
            onClicked: skeleton.state = "spineboy"
        }
        Button{
            text:"Goblins"
            onClicked: skeleton.state = "goblins"
        }
    }
    Rectangle {
        id: txtRect
        color: Qt.rgba(1, 1, 1, 0.7)
        radius: 8
        border.width: 1
        border.color: "white"
        width: txt.width + 10
        height: button.height
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 4
        anchors.horizontalCenter: parent.horizontalCenter
        Text{
            id: txt
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            text:"Click above to change the animation (Spineboy) or skin (Goblins). "
        }
    }
}
