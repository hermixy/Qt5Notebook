import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.4
import an.qt.HandleHumiture 1.0

Rectangle {
    color: "transparent";

    HandleHumiture {
        id: modifyCmdHanle;
    }

    GridLayout {
       rows: 5;
       columns: 6;
       rowSpacing: 10;
       columnSpacing: 10;

       ULabel {
           Layout.topMargin: 30;
           Layout.row: 0; Layout.column: 0;
           Layout.columnSpan: 6;
           text: "修改参数指令(06指令): 用来修改设备参数";
       }

       ULabel {
           Layout.row: 1; Layout.column: 0;
           text: "设备地址:";
       }
       UTextField {
           id: deviceAddr;
           Layout.row: 1; Layout.column: 1;
           placeholderText: "01";
       }

       ULabel {
           Layout.row: 1; Layout.column: 2;
           text: "寄存器起始地址:";
       }
       UTextField {
           id: registerAddr;
           Layout.row: 1; Layout.column: 3;
           placeholderText: "0000";
       }

       ULabel {
           Layout.row: 1; Layout.column: 4;
           text: "需写入的数据:";
       }
       UTextField {
           id: data;
           Layout.row: 1; Layout.column: 5;
           placeholderText: "0001";
       }

       ULabel {
           Layout.row: 2; Layout.column: 0;
           text: "发送:"
       }
       UTextField {
           Layout.row: 2; Layout.column: 1;
           Layout.columnSpan: 5;
           implicitWidth: 500;
           placeholderText: "000600000001";
       }
       ULabel {
           Layout.row: 3; Layout.column: 0;
           text: "响应:";
       }
       UTextField {
           id: dataField;
           Layout.row: 3; Layout.column: 1;
           Layout.columnSpan: 5;
           implicitWidth: 500;
       }

       UButton {
           Layout.row: 4; Layout.column: 5;
           text: "写入";
           onClicked: {
               var devAddr = parseInt(deviceAddr.text);
               var regAddr = parseInt(registerAddr.text);
               var inputData = parseInt(data.text);
               modifyCmdHanle.onModifyCmd(devAddr, regAddr, inputData);
           }
       }
    }

    Connections {
        target: modifyCmdHanle;
        onModifyCmd: {
            dataField.text = data;
        }
    }
}
