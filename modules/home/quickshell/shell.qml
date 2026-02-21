//@ pragma UseQApplication

import Quickshell
import QtQuick

import "./Windows" as Windows
import "./Modules/" as Modules

ShellRoot {
    id: root

    Windows.Bar {}
    Windows.ControlCenter {}
}
