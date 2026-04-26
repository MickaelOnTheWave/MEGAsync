import QtQuick 2.15
import QtQuick.Layouts 1.15

import common 1.0
import components.buttons 1.0 as Buttons
import components.texts 1.0 as Texts
import components.images 1.0
import AccountStateQuickWidget 1.0

Item {
    id: root

    property int state: AccountStateQuickWidget.OK
    property string centerText: ""
    property var segments: []
    property bool showLegend: true

    property int defaultMargin: 12
    property int tightSpacing: 2
    property int smallSpacing: 4
    property int compactSpacing: 8
    property int defaultIconSize: 16
    property int bannerTextPixelSize: 12
    property int bannerTextLineHeight: 18
    property int minVisibleSegmentWidth: 4
    
    signal bannerActionClicked()

    function hasStateBanner() {
        return state === AccountStateQuickWidget.WARNING
               || state === AccountStateQuickWidget.FULL
    }

    function normalStateColorForType(type) {
        switch (type) {
        case AccountStateQuickWidget.CloudDrive:
            return ColorTheme.indicatorGreen
        case AccountStateQuickWidget.Backups:
            return ColorTheme.indicatorIndigo
        case AccountStateQuickWidget.Versions:
            return ColorTheme.supportSuccess
        case AccountStateQuickWidget.Free:
            return ColorTheme.surface3
        case AccountStateQuickWidget.RubbishBin:
            return ColorTheme.iconAccent
        case AccountStateQuickWidget.Other:
            return ColorTheme.surface3
        default:
            return ColorTheme.indicatorGreen
        }
    }

    function warningStateColorForType(type) {
        switch (type) {
        case AccountStateQuickWidget.CloudDrive:
            return ColorTheme.indicatorGreen
        case AccountStateQuickWidget.Backups:
            return ColorTheme.indicatorIndigo
        case AccountStateQuickWidget.Versions:
            return ColorTheme.supportSuccess
        case AccountStateQuickWidget.Free:
            return ColorTheme.surface3
        case AccountStateQuickWidget.RubbishBin:
            return ColorTheme.iconAccent
        case AccountStateQuickWidget.Other:
            return ColorTheme.surface3
        default:
            return ColorTheme.indicatorGreen
        }
    }

    function fullStateColorForType(type) {
        switch (type) {
        case AccountStateQuickWidget.CloudDrive:
            return ColorTheme.buttonError
        case AccountStateQuickWidget.Backups:
            return ColorTheme.buttonErrorHover
        case AccountStateQuickWidget.Versions:
            return ColorTheme.buttonErrorHover
        case AccountStateQuickWidget.Free:
            return ColorTheme.surface3
        case AccountStateQuickWidget.RubbishBin:
            return ColorTheme.buttonErrorPressed
        case AccountStateQuickWidget.Other:
            return ColorTheme.buttonErrorPressed
        default:
            return ColorTheme.buttonError
        }
    }

    function bannerBackgroundColor() {
        return state === AccountStateQuickWidget.FULL
               ? ColorTheme.notificationError
               : ColorTheme.notificationWarning
    }

    function bannerAccentColor() {
        return state === AccountStateQuickWidget.FULL ? ColorTheme.textError
                                                      : ColorTheme.textWarning
    }

    function bannerTitle() {
        return state === AccountStateQuickWidget.FULL
               ? SettingsStrings.yourMegaAccountIsFull
               : SettingsStrings.yourMegaAccountIsNearlyFull
    }

    function bannerDescription() {
        return state === AccountStateQuickWidget.FULL
               ? SettingsStrings.uploadsDisabledDescription
               : SettingsStrings.nearlyFullDescription
    }

    function segmentFillColor(segment) {
        if (!segment) {
            return ColorTheme.indicatorGreen
        }

        const type = Number(segment.type)

        if (state === AccountStateQuickWidget.FULL) {
            return root.fullStateColorForType(type)
        }

        if (state === AccountStateQuickWidget.WARNING) {
            return root.warningStateColorForType(type)
        }

        return root.normalStateColorForType(type)
    }

    function legendSegments() {
        let legend = []

        ;(root.segments || []).forEach(function(segment) {
            if (Number(segment.type) === AccountStateQuickWidget.Free) {
                return
            }

            legend.push(segment)
            ;(segment.children || []).forEach(function(childSegment) {
                if (childSegment && Number(childSegment.value) > 0) {
                    legend.push(childSegment)
                }
            })
        })

        return legend
    }

    function tooltipTextForSegment(segment) {
        if (!segment) {
            return ""
        }

        const type = Number(segment.type)
        const label = segment.label || ""
        const sizeText = segment.sizeText || ""

        if (sizeText.length > 0) {
            switch (type) {
            case AccountStateQuickWidget.CloudDrive:
                return SettingsStrings.cloudDriveTooltipFormat.arg(sizeText).replace("[BR]", "\n")
            case AccountStateQuickWidget.Backups:
                return SettingsStrings.backupsTooltipFormat.arg(sizeText).replace("[BR]", "\n")
            case AccountStateQuickWidget.Versions:
                return SettingsStrings.versionsTooltipFormat.arg(sizeText).replace("[BR]", "\n")
            case AccountStateQuickWidget.Free:
                return SettingsStrings.availableTooltipFormat.arg(sizeText).replace("[BR]", "\n")
            case AccountStateQuickWidget.RubbishBin:
                return SettingsStrings.rubbishBinTooltipFormat.arg(sizeText).replace("[BR]", "\n")
            case AccountStateQuickWidget.Downloads:
                return SettingsStrings.downloadsTooltipFormat.arg(sizeText).replace("[BR]", "\n")
            default:
                return label
            }
        }

        return label
    }

    clip: true
    implicitHeight: progressColumn.implicitHeight

    ColumnLayout {
        id: progressColumn

        anchors.fill: parent
        spacing: root.defaultMargin

        Item {
            id: progressBarContainer

            Layout.fillWidth: true
            implicitHeight: 24

            Rectangle {
                id: progressTrack

                anchors.fill: parent
                radius: 4
                color: ColorTheme.surface3
            }

            QuotaProgressSegments {
                anchors.fill: parent
                segments: root.segments
                segmentFillColor: root.segmentFillColor
                tooltipTextForSegment: root.tooltipTextForSegment
                shouldRoundLastSegment: true
                tightSpacing: root.tightSpacing
                segmentRadius: 4
                minVisibleSegmentWidth: root.minVisibleSegmentWidth
            }

            Texts.Text {
                id: centerTextLabel

                anchors.centerIn: parent
                visible: root.centerText.length > 0
                text: root.centerText
                color: ColorTheme.textPrimary
                font.pixelSize: Texts.Text.Size.NORMAL
                font.weight: Font.DemiBold
            }
        }

        RowLayout {
            id: legendLayout

            Layout.fillWidth: true
            visible: root.showLegend
            spacing: 24

            Repeater {
                id: legendRepeater

                model: root.legendSegments()

                RowLayout {
                    id: legendItemLayout

                    required property var modelData

                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    spacing: root.tightSpacing

                    Item {
                        id: legendItemContainer

                        implicitWidth: legendItemRow.implicitWidth
                        implicitHeight: legendItemRow.implicitHeight

                        RowLayout {
                            id: legendItemRow

                            anchors.fill: parent
                            spacing: root.tightSpacing

                            Item {
                                id: legendDotContainer

                                implicitWidth: 16
                                implicitHeight: 16

                                Rectangle {
                                    id: legendDot

                                    anchors.centerIn: parent
                                    width: 7.5
                                    height: 7.5
                                    radius: width / 2
                                    color: root.segmentFillColor(modelData)
                                }
                            }

                            Texts.Text {
                                id: legendText

                                text: modelData.label
                                font.pixelSize: 10
                                font.weight: Font.DemiBold
                                lineHeight: 16
                                lineHeightMode: Text.FixedHeight
                                color: ColorTheme.textSecondary
                                renderType: Text.NativeRendering // Avoids the slightly blurred text appearance from default QML rendering in embedded QQuickWidget content.
                            }
                        }

                        MouseArea {
                            id: legendMouseArea

                            anchors.fill: parent
                            hoverEnabled: true

                            QuotaProgressToolTip {
                                visible: legendMouseArea.containsMouse
                                text: root.tooltipTextForSegment(legendItemLayout.modelData)
                                anchorItem: legendItemContainer
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: stateBanner

            Layout.fillWidth: true
            visible: root.hasStateBanner()
            radius: 8
            color: root.bannerBackgroundColor()
            implicitHeight: bannerRow.implicitHeight + 24

            RowLayout {
                id: bannerRow

                anchors {
                    fill: parent
                    leftMargin: root.defaultMargin
                    topMargin: root.defaultMargin
                    rightMargin: 20 - bannerActionButton.sizes.focusBorderWidth
                    bottomMargin: root.defaultMargin
                }
                spacing: root.smallSpacing

                RowLayout {
                    id: bannerContentLayout

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    spacing: root.compactSpacing

                    SvgImage {
                        id: bannerIcon

                        Layout.alignment: Qt.AlignTop
                        source: root.state === AccountStateQuickWidget.FULL
                                ? Images.alertCircle
                                : Images.alertTriangle
                        color: root.bannerAccentColor()
                        sourceSize: Qt.size(root.defaultIconSize, root.defaultIconSize)
                    }

                    ColumnLayout {
                        id: bannerTextLayout

                        Layout.fillWidth: true
                        spacing: root.smallSpacing

                        Texts.Text {
                            id: bannerTitleText

                            Layout.fillWidth: true
                            text: root.bannerTitle()
                            color: ColorTheme.textPrimary
                            font.pixelSize: root.bannerTextPixelSize
                            font.weight: Font.DemiBold
                            lineHeight: root.bannerTextLineHeight
                            lineHeightMode: Text.FixedHeight
                            renderType: Text.NativeRendering // Avoids the slightly blurred text appearance from default QML rendering in embedded QQuickWidget content.
                        }

                        Texts.Text {
                            id: bannerDescriptionText

                            Layout.fillWidth: true
                            text: root.bannerDescription()
                            color: ColorTheme.textPrimary
                            wrapMode: Text.WordWrap
                            font.pixelSize: root.bannerTextPixelSize
                            font.weight: Font.Normal
                            lineHeight: root.bannerTextLineHeight
                            lineHeightMode: Text.FixedHeight
                            renderType: Text.NativeRendering // Avoids the slightly blurred text appearance from default QML rendering in embedded QQuickWidget content.
                        }
                    }
                }

                Buttons.PrimaryButton {
                    id: bannerActionButton

                    Layout.alignment: Qt.AlignVCenter
                    text: SettingsStrings.buyMoreStorage
                    onClicked: root.bannerActionClicked()
                }
            }
        }
    }
}
