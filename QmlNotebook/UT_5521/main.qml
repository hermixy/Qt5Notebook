import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4

/*
* 自定义标题栏的框架
*/
ApplicationWindow {
    id: root;
    visible: true;
    width: 640;
    height: 480;
    flags: Qt.Window | Qt.FramelessWindowHint;

    function updatePosition(mouseOld, mouseNew){
        var deltaX = (mouseNew.x - mouseOld.x);
        var deltaY = (mouseNew.y - mouseOld.y);
        root.setX(root.x + deltaX);
        root.setY(root.y + deltaY);
        root.width = root.width + deltaX;
        root.height = root.height + deltaY;
    }

    MouseArea {
        id: rootMouseArea;
        anchors.fill: parent;
        acceptedButtons: Qt.LeftButton;
        hoverEnabled: true;
        /*
        * 将界面分成一个九宫格分别为: LeftTop Top RightTop Left Center Right
        * LeftBottom Bottom RightBottom, 鼠标在这九个区域内需要做特殊处理.
        * 边界缩放范围 step = 5, 也就是说鼠标在四边 step 范围内且没有按住左键
        * 的情况下，只改变鼠标形状，按住了左键然后移动鼠标，就需要处理缩放界面.
        * 如果在边界缩放范围外，且在界面内任何主界面(非子控件),都正常显示鼠标
        * 形状，如果按住左键并移动鼠标，则移动主界面，放开鼠标左键，则恢复鼠标形状
        */
        property point clickPos: "0,0"

        // 边框缩放的范围
        property int step: 10;
        // 是否点击
        property bool isClicked: false;
        // 鼠标的状态
        property int mouseState: 0
        // 最小宽高
        property int minWidthHeight:30;

        onPressed: {
            focus = true;
            isClicked = true;
            clickPos = Qt.point(mouse.x, mouse.y)
            mouse.accepted = true;
        }
        onReleased: {
            isClicked = false;
            mouse.accepted = true;
        }

        onPositionChanged: {
            if(isClicked)
            {
                //鼠标偏移量
                var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                switch(mouseState){
                case 0:
                case 5:
                    root.setX(root.x + delta.x)
                    root.setY(root.y + delta.y)
                    break;
                case 1:
                    root.width = root.width - delta.x;
                    root.height = root.height - delta.y
                    root.setX(root.x + delta.x)
                    root.setY(root.y + delta.y)
                    break;
                case 2:
                    root.width = root.width - delta.x;
                    root.setX(root.x + delta.x)
                    break;
                case 3:
                    root.width = root.width - delta.x;
                    root.height = root.height + delta.y;
                    root.setX(root.x + delta.x)
                    clickPos = Qt.point(mouse.x, mouse.y)
                    break;
                case 4:
                    root.height = root.height - delta.y
                    root.setY(root.y + delta.y)
                    break;
                case 6:
                    root.height = root.height + delta.y;
                    clickPos = Qt.point(mouse.x, mouse.y)
                    break;
                case 7:
                    root.width = root.width + delta.x;
                    root.height = root.height - delta.y;
                    root.setY(root.y + delta.y)
                    clickPos = Qt.point(mouse.x, mouse.y)
                    break;
                case 8:
                    root.width = root.width + delta.x;
                    clickPos = Qt.point(mouse.x, mouse.y)
                    break;
                case 9:
                    root.width = root.width + delta.x;
                    root.height = root.height + delta.y;
                    clickPos = Qt.point(mouse.x, mouse.y)
                    break;
                default:
                    break;
                }
                // 防止页面消失
                if(root.width < minWidthHeight){
                    root.width = minWidthHeight;
                }
                if(root.height < minWidthHeight){
                    root.height = minWidthHeight;
                }

            }
            else
            {
                // 没有按左键，只需要改变鼠标形状
                if(mouseX <= step && mouseX > 0){
                    // 九宫格左侧三个格子,宽度 step, 分别处理三个格子区域的鼠标形状
                    if(mouseY < step && mouseY > 0){
                        // 第一行
                        mouseState = 1;
                        rootMouseArea.cursorShape = Qt.SizeFDiagCursor;
                    }
                    else if(mouseY >= step && mouseY < root.height - step){
                        // 第二行
                        mouseState = 2;
                        rootMouseArea.cursorShape = Qt.SizeHorCursor;
                    }
                    else if(mouseY >= root.height - step && mouseY <= root.height){
                        // 第三行
                        mouseState = 3;
                        rootMouseArea.cursorShape = Qt.SizeBDiagCursor;
                    }
                }
                else if(mouseX > step && mouseX < root.width - step){
                    // 九宫格中间第二列的三行
                    if(mouseY < step && mouseY > 0){
                        mouseState = 4;
                        rootMouseArea.cursorShape = Qt.SizeVerCursor;
                    }
                    else if(mouseY >= step && mouseY < root.height - step){
                        mouseState = 5;
                        rootMouseArea.cursorShape = Qt.ArrowCursor;
                    }
                    else if(mouseY >= root.height - step && mouseY <= root.height){
                        mouseState = 6;
                        rootMouseArea.cursorShape = Qt.SizeVerCursor;
                    }
                }
                else if(mouseX >= root.width - step && mouseX <= root.width){
                    // 九宫格中间第三列的三行, 第三列第三行的运行结果鼠标显示切换不明显，故范围扩大到 2 * step
                    if(mouseY <= step && mouseY > 0){
                        mouseState = 7;
                        rootMouseArea.cursorShape = Qt.SizeBDiagCursor;
                    }
                    else if(mouseY > step && mouseY < root.height - 2 * step){
                        mouseState = 8;
                        rootMouseArea.cursorShape = Qt.SizeHorCursor;
                    }
                    else if(mouseY >= root.height - 2 * step && mouseY <= root.height){
                        mouseState = 9;
                        rootMouseArea.cursorShape = Qt.SizeFDiagCursor;
                    }
                }
            }
            mouse.accepted = true;
        }
    }

    // 标题栏
    Rectangle {
        width: parent.width;
        height: 30;
//        color: "#00A600";

        Button {
            id: close;
            height: parent.height;
            width: 40;
            anchors.right: parent.right;
            anchors.top: parent.top;
            style: ButtonStyle {
                radius: 4;
            }
        }
    }
    // 侧边导航栏
    Rectangle {
        width: 160;
        height: parent.height;
        color: "gray";

        Flow {
            width: parent.width;
            height: parent.height;
            flow: Flow.TopToBottom;
            Label {
                width: parent.width;
                height: 60;
                text: "LOGO";
                color: "blue";
            }

            Button {
                width: parent.width;
                height: 60;
                id: control
                text: qsTr("主页")

                background: Rectangle {
                    implicitWidth: parent.width;
                    implicitHeight: 60;
                    opacity: enabled ? 1 : 0.3;
                    border.color: control.down ? "#17a81a" : "#21be2b";
                    border.width: 1;
                    radius: 2;
                    color: "red";
                }
            }
        }

    }
}