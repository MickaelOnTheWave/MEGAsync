import QtQuick 2.15
import QtQuick.Layouts 1.15

import common 1.0
import components.texts 1.0 as Texts

Item {
    id: root

    ColumnLayout {
        id: contentLayout

        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 48

        Item {
            id: storageCard

            visible: accountStateAccess.showStorageCard
            Layout.fillWidth: true
            implicitHeight: storageContent.implicitHeight

            ColumnLayout {
                id: storageContent

                anchors.fill: parent
                anchors.margins: 0
                spacing: 4

                RowLayout {
                    id: storageHeaderLayout

                    Layout.fillWidth: true
                    spacing: 12

                    Texts.Text {
                        id: storageTitleText

                        Layout.fillWidth: true
                        text: SettingsStrings.storageSpace
                        font.pixelSize: 10
                        font.weight: Font.DemiBold
                        elide: Text.ElideRight
                        renderType: Text.NativeRendering  // Avoids the slightly blurred text appearance from default QML rendering in embedded QQuickWidget content.
                    }

                    Texts.Text {
                        id: storageSummaryText

                        Layout.rightMargin: 12
                        text: accountStateAccess.storageSummary
                        font.pixelSize: 12
                        font.weight: Font.DemiBold
                        horizontalAlignment: Text.AlignRight
                        renderType: Text.NativeRendering // Avoids the slightly blurred text appearance from default QML rendering in embedded QQuickWidget content.
                    }
                }

                Rectangle {
                    id: storageDivider

                    Layout.fillWidth: true
                    implicitHeight: 1
                    color: ColorTheme.borderStrong
                }

                SettingsLinearProgress {
                    id: storageProgress

                    Layout.fillWidth: true
                    Layout.topMargin: 12
                    state: accountStateAccess.storageState
                    segments: accountStateAccess.storageSegments
                    onBannerActionClicked: accountStateAccess.upgradeRequested()
                }
            }
        }

        Item {
            id: transferCard

            visible: accountStateAccess.showTransferCard
            Layout.fillWidth: true
            implicitHeight: transferContent.implicitHeight

            ColumnLayout {
                id: transferContent

                anchors.fill: parent
                anchors.margins: 0
                spacing: 4

                RowLayout {
                    id: transferHeaderLayout

                    Layout.fillWidth: true
                    spacing: 12

                    Texts.Text {
                        id: transferTitleText

                        Layout.fillWidth: true
                        text: SettingsStrings.transferQuota
                        font.pixelSize: 10
                        font.weight: Font.DemiBold
                        elide: Text.ElideRight
                        renderType: Text.NativeRendering // Avoids the slightly blurred text appearance from default QML rendering in embedded QQuickWidget content.
                    }

                    Texts.Text {
                        id: transferSummaryText

                        Layout.rightMargin: 12
                        text: accountStateAccess.transferSummary
                        font.pixelSize: 12
                        font.weight: Font.DemiBold
                        horizontalAlignment: Text.AlignRight
                        renderType: Text.NativeRendering // Avoids the slightly blurred text appearance from default QML rendering in embedded QQuickWidget content.
                    }
                }

                Rectangle {
                    id: transferDivider

                    Layout.fillWidth: true
                    implicitHeight: 1
                    color:ColorTheme.borderStrong
                }

                SettingsLinearProgress {
                    id: transferProgress
                    Layout.fillWidth: true
                    Layout.topMargin: 12
                    visible: !accountStateAccess.transferValueOnly
                    state: accountStateAccess.transferState
                    segments: accountStateAccess.transferSegments
                    onBannerActionClicked: accountStateAccess.upgradeRequested()
                }

                Texts.Text {
                    id: transferValueText

                    Layout.fillWidth: true
                    Layout.topMargin: 8
                    visible: accountStateAccess.transferValueOnly
                    text: accountStateAccess.transferValueText
                    font.pixelSize: 12
                    font.weight: Font.DemiBold
                    renderType: Text.NativeRendering
                }
            }
        }

        Item {
            id: spacerItem

            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
