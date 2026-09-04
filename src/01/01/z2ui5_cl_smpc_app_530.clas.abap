" @keywords generictag generic tag sap.m overflowtoolbarsimple messagestrip slider overflowtoolbar label toolbarspacer button overflowtoolbarlayoutdata
" @summary Overflow Toolbar can contain the same controls as Toolbar with the added benefit that buttons that do not fit are moved to an overflow area when overflow occurs.
CLASS z2ui5_cl_smpc_app_530 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA viewport TYPE i VALUE 100.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_530 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA width TYPE string.
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " onSliderMoved calls setWidth( value && '%' ) on all TEN toolbars - the port
    " gives every toolbar the same expression binding over the two-way slider
    " value, so the resize needs no round-trip at all
    
    width = |\{= ${ client->_bind( viewport ) } + '%' \}|.

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `Share action` INTO TABLE temp1.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`

        )->tag( `MessageStrip`
            )->a( n = `class`    v = `sapUiTinyMargin`
            )->a( n = `text`     v = `Use this slider to resize the toolbars and observe their behaviour.`
            )->a( n = `type`     v = `Information`
            )->a( n = `showIcon` v = `true`
        )->tag( `Slider`
            )->a( n = `value` v = client->_bind( viewport )

        )->tag( `MessageStrip`
            )->a( n = `class`    v = `sapUiTinyMargin`
            )->a( n = `text`     v = `When buttons have no special layout, they are all moved to the overflow area.`
            )->a( n = `type`     v = `Information`
            )->a( n = `showIcon` v = `true`

        )->ele( `OverflowToolbar`
            )->a( n = `id`    v = `otb1`
            )->a( n = `width` v = width

            )->tag( `Label`
                )->a( n = `text` v = `Buttons:`
            )->tag( `ToolbarSpacer`
            )->tag( `Button`
                )->a( n = `text` v = `New`
                )->a( n = `type` v = `Transparent`
            )->tag( `Button`
                )->a( n = `text` v = `Open`
                )->a( n = `type` v = `Transparent`
            )->tag( `Button`
                )->a( n = `text` v = `Save`
                )->a( n = `type` v = `Transparent`
            )->tag( `Button`
                )->a( n = `text` v = `Save as`
                )->a( n = `type` v = `Transparent`
            )->tag( `Button`
                )->a( n = `text` v = `Cut`
                )->a( n = `type` v = `Transparent`
            )->tag( `Button`
                )->a( n = `text` v = `Copy`
                )->a( n = `type` v = `Transparent`
            )->tag( `Button`
                )->a( n = `text` v = `Paste`
                )->a( n = `type` v = `Transparent`
            )->tag( `Button`
                )->a( n = `text` v = `Undo`
                )->a( n = `type` v = `Transparent`
            )->tag( `Button`
                )->a( n = `text` v = `Redo`
                )->a( n = `type` v = `Transparent`
            " press="cmd:Share" runs the CommandExecution the view declares in
            " mvc:dependents - no controller here, so the press carries the
            " shareAction toast itself (see sidecar)
            )->tag( `Button`
                )->a( n = `text`  v = `Share`
                )->a( n = `type`  v = `Transparent`
                )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                t_arg = temp1 )

        )->end(

        )->tag( `Label`

        )->tag( `MessageStrip`
            )->a( n = `class`    v = `sapUiTinyMargin`
            )->a( n = `text`     v = `The Cut, Copy and Paste buttons have a special layout and never move to the overflow area.`
            )->a( n = `type`     v = `Information`
            )->a( n = `showIcon` v = `true`

        )->ele( `OverflowToolbar`
            )->a( n = `id`    v = `otb2`
            )->a( n = `width` v = width

            )->tag( `Label`
                )->a( n = `text` v = `Buttons:`
            )->tag( `ToolbarSpacer`
            )->tag( `Button`
                )->a( n = `text` v = `New`
                )->a( n = `type` v = `Transparent`
            )->tag( `Button`
                )->a( n = `text` v = `Open`
                )->a( n = `type` v = `Transparent`
            )->tag( `Button`
                )->a( n = `text` v = `Save`
                )->a( n = `type` v = `Transparent`
            )->tag( `Button`
                )->a( n = `text` v = `Save as`
                )->a( n = `type` v = `Transparent`
            )->ele( `Button`
                )->a( n = `text` v = `Cut`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text` v = `Copy`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text` v = `Paste`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->end(
            )->end(
            )->tag( `Button`
                )->a( n = `text` v = `Undo`
                )->a( n = `type` v = `Transparent`
            )->tag( `Button`
                )->a( n = `text` v = `Redo`
                )->a( n = `type` v = `Transparent`

        )->end(

        )->tag( `Label`

        )->tag( `MessageStrip`
            )->a( n = `class`    v = `sapUiTinyMargin`
            )->a( n = `text`     v = `The last two buttons have a special layout to always stay in the overflow area. Even if there is enough space for them, they will not be displayed.`
            )->a( n = `type`     v = `Information`
            )->a( n = `showIcon` v = `true`

        )->ele( `OverflowToolbar`
            )->a( n = `id`    v = `otb3`
            )->a( n = `width` v = width

            )->tag( `Label`
                )->a( n = `text` v = `Buttons:`
            )->tag( `ToolbarSpacer`
            )->tag( `Button`
                )->a( n = `text` v = `New`
                )->a( n = `type` v = `Transparent`
            )->tag( `Button`
                )->a( n = `text` v = `Open`
                )->a( n = `type` v = `Transparent`
            )->tag( `Button`
                )->a( n = `text` v = `Save`
                )->a( n = `type` v = `Transparent`
            )->tag( `Button`
                )->a( n = `text` v = `Save as`
                )->a( n = `type` v = `Transparent`
            )->tag( `Button`
                )->a( n = `text` v = `Cut`
                )->a( n = `type` v = `Transparent`
            )->tag( `Button`
                )->a( n = `text` v = `Copy`
                )->a( n = `type` v = `Transparent`
            )->tag( `Button`
                )->a( n = `text` v = `Paste`
                )->a( n = `type` v = `Transparent`
            )->ele( `Button`
                )->a( n = `text` v = `Undo`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `AlwaysOverflow`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text` v = `Redo`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `AlwaysOverflow`

                )->end(
            )->end(
        )->end(

        )->tag( `Label`

        )->tag( `MessageStrip`
            )->a( n = `class`    v = `sapUiTinyMargin`
            )->a( n = `text`     v = `The available priorities for the toolbar items are: AlwaysOverflow, Disappear, Low, High and NeverOverflow. By default the priority of each toolbar item is High. Items with AlwaysOverflow priority remain visible ` &&
                                     `in the overflow area. Items with NeverOverflow priority remain visible in the toolbar. Items with Disappear, Low and High priority overflow depending on their priority and position in the toolbar. Items with ` &&
                                     `Disappear priority overflow but they are not displayed in the overflow area.`
            )->a( n = `type`     v = `Information`
            )->a( n = `showIcon` v = `true`

        )->ele( `OverflowToolbar`
            )->a( n = `id`    v = `otb4`
            )->a( n = `width` v = width

            )->tag( `Label`
                )->a( n = `text` v = `Buttons:`
            )->tag( `Label`
            )->tag( `ToolbarSpacer`
            )->ele( `Button`
                )->a( n = `text` v = `Always 1`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `AlwaysOverflow`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text` v = `Always 2`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `AlwaysOverflow`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text` v = `Never`
                )->a( n = `type` v = `Emphasized`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->end(
            )->end(
            )->tag( `Button`
                )->a( n = `text` v = `Default`
                )->a( n = `type` v = `Transparent`
            )->ele( `Button`
                )->a( n = `text` v = `Low 1`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `Low`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text` v = `High 1`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `High`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text` v = `Disappear`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `Disappear`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text` v = `High 2`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `High`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text` v = `Low 2`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `Low`

                )->end(
            )->end(
        )->end(

        )->tag( `MessageStrip`
            )->a( n = `class`    v = `sapUiTinyMargin`
            )->a( n = `text`     v = `Toolbar items can overflow together even if they are on different positions. This is possible using the group property of the OverflowToolbarLayoutData element. By default the group value is 0, which means that ` &&
                                     `the element does not belong to any group. When two or more elements have the same group value, this means that they belong to the same group. Elements that belong to a group are not allowed to have AlwaysOverflow ` &&
                                     `or NeverOverflow priority.`
            )->a( n = `type`     v = `Information`
            )->a( n = `showIcon` v = `true`

        )->ele( `OverflowToolbar`
            )->a( n = `id`    v = `otb5`
            )->a( n = `width` v = width

            )->tag( `Label`
                )->a( n = `text` v = `Buttons:`
            )->tag( `Label`
            )->tag( `ToolbarSpacer`
            )->ele( `Button`
                )->a( n = `text` v = `Always 1`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `AlwaysOverflow`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text` v = `Always 2`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `AlwaysOverflow`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text` v = `Never`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text` v = `Group 1`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `High`
                        )->a( n = `group`    v = `1`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text` v = `Group 1`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `High`
                        )->a( n = `group`    v = `1`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text` v = `Disappear`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `Disappear`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text` v = `Group 2`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `Low`
                        )->a( n = `group`    v = `2`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text` v = `Group 2`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `Low`
                        )->a( n = `group`    v = `2`

                )->end(
            )->end(
        )->end(

        )->tag( `MessageStrip`
            )->a( n = `class`    v = `sapUiTinyMargin`
            )->a( n = `text`     v = `Toolbar separators are shown as horizontal lines in the overflow area. If the separator happens to be the first or the last element in the overflow area, it won't be displayed. It is recommended to use the ` &&
                                     `separator within group, so it won't be left behind in an inappropriate positions.`
            )->a( n = `type`     v = `Information`
            )->a( n = `showIcon` v = `true`

        )->ele( `OverflowToolbar`
            )->a( n = `id`    v = `otb6`
            )->a( n = `width` v = width

            )->tag( `Label`
                )->a( n = `text` v = `Buttons within separated groups:`
            )->tag( `Label`
            )->tag( `ToolbarSpacer`
            )->ele( `Button`
                )->a( n = `text` v = `Never`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text` v = `Group 1`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `group` v = `1`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text` v = `Group 1`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `group` v = `1`

                )->end(
            )->end(
            )->ele( `ToolbarSeparator`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `group` v = `2`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text` v = `Group 2`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `group` v = `2`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text` v = `Group 2`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `group` v = `2`

                )->end(
            )->end(
        )->end(

        )->tag( `MessageStrip`
            )->a( n = `class`    v = `sapUiTinyMargin`
            )->a( n = `text`     v = `Segmented buttons are shown as Selects when in the overflow area.`
            )->a( n = `type`     v = `Information`
            )->a( n = `showIcon` v = `true`

        )->ele( `OverflowToolbar`
            )->a( n = `id`    v = `otb7`
            )->a( n = `width` v = width

            )->tag( `ToolbarSpacer`
            )->ele( `Select`

                )->ele( `items`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `1`
                        )->a( n = `text` v = `Option 1`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `2`
                        )->a( n = `text` v = `Option 2`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `3`
                        )->a( n = `text` v = `Option 3`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `4`
                        )->a( n = `text` v = `Option 4`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `5`
                        )->a( n = `text` v = `Option 5`

                )->end(
            )->end(
            )->tag( `Button`
                )->a( n = `text` v = `Button 1`
                )->a( n = `type` v = `Transparent`
            )->tag( `Button`
                )->a( n = `text` v = `Button 2`
                )->a( n = `type` v = `Transparent`
            )->tag( `ToggleButton`
                )->a( n = `text` v = `Toggle Button`
                )->a( n = `type` v = `Transparent`
            )->tag( `Button`
                )->a( n = `text` v = `Button 3`
                )->a( n = `type` v = `Transparent`
            )->ele( `SegmentedButton`
                )->a( n = `tooltip` v = `Segmented Button`

                )->ele( `items`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `text` v = `Segmented`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `text` v = `Button`

                )->end(
            )->end(
            )->tag( `Button`
                )->a( n = `text` v = `Button 4`
                )->a( n = `type` v = `Transparent`

        )->end(

        )->tag( `MessageStrip`
            )->a( n = `class`    v = `sapUiTinyMargin`
            )->a( n = `text`     v = `Toolbar items with shrinkable LayoutData and minWidth`
            )->a( n = `type`     v = `Information`
            )->a( n = `showIcon` v = `true`

        )->ele( `OverflowToolbar`
            )->a( n = `id`    v = `otb8`
            )->a( n = `width` v = width

            )->tag( `Label`
                )->a( n = `text` v = `Buttons:`

            )->ele( `layoutData`
                )->tag( `OverflowToolbarLayoutData`
                    )->a( n = `shrinkable` v = `true`
                    )->a( n = `minWidth`   v = `100px`

            )->end(

            )->tag( `Label`
            )->ele( `Button`
                )->a( n = `text` v = `Min width 50px`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `shrinkable` v = `true`
                        )->a( n = `minWidth`   v = `50px`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text` v = `Min width 100px`
                )->a( n = `type` v = `Transparent`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `shrinkable` v = `true`
                        )->a( n = `minWidth`   v = `100px`

                )->end(
            )->end(
            )->tag( `ToolbarSpacer`
            )->ele( `Select`

                )->ele( `items`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `1`
                        )->a( n = `text` v = `Option 1`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `2`
                        )->a( n = `text` v = `Option 2`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `3`
                        )->a( n = `text` v = `Option 3`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `4`
                        )->a( n = `text` v = `Option 4`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `5`
                        )->a( n = `text` v = `Option 5`

                )->end(

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `shrinkable` v = `true`
                        )->a( n = `minWidth`   v = `150px`

                )->end(
            )->end(
            )->ele( `Input`
                )->a( n = `width`       v = `10%`
                )->a( n = `placeholder` v = `Input`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `shrinkable` v = `true`
                        )->a( n = `minWidth`   v = `50px`

                )->end(
            )->end(
            )->ele( `SearchField`
                )->a( n = `width`       v = `10%`
                )->a( n = `placeholder` v = `Search`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `shrinkable` v = `true`
                        )->a( n = `minWidth`   v = `100px`

                )->end(
            )->end(
            )->tag( `ToolbarSpacer`
            )->ele( `CheckBox`
                )->a( n = `text` v = `I'm a CheckBox!`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `shrinkable` v = `true`
                        )->a( n = `minWidth`   v = `30px`

                )->end(
            )->end(
            )->ele( `RadioButton`
                )->a( n = `text` v = `I'm a radio button!`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `shrinkable` v = `true`
                        )->a( n = `minWidth`   v = `100px`

                )->end(
            )->end(
        )->end(

        )->tag( `MessageStrip`
            )->a( n = `class`    v = `sapUiTinyMargin`
            )->a( n = `text`     v = `Overflow Toolbar with grouped elements: Label with Select and Label with Input. Grouped elements move inside Overflow Toolbar in pairs.`
            )->a( n = `type`     v = `Information`
            )->a( n = `showIcon` v = `true`

        )->ele( `OverflowToolbar`
            )->a( n = `id`    v = `otb9`
            )->a( n = `width` v = width

            )->tag( `Label`
                )->a( n = `text` v = `Grouping:`
            )->tag( `ToolbarSpacer`
            )->ele( `Label`
                )->a( n = `text`     v = `Select:`
                )->a( n = `labelFor` v = `labeledSelectGroup1`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `group` v = `1`

                )->end(
            )->end(
            )->ele( `Select`
                )->a( n = `width` v = `20%`
                )->a( n = `id`    v = `labeledSelectGroup1`

                )->ele( `items`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `1`
                        )->a( n = `text` v = `Option 1`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `2`
                        )->a( n = `text` v = `Option 2`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `3`
                        )->a( n = `text` v = `Option 3`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `4`
                        )->a( n = `text` v = `Option 4`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `5`
                        )->a( n = `text` v = `Option 5`

                )->end(

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `group`      v = `1`
                        )->a( n = `shrinkable` v = `true`
                        )->a( n = `minWidth`   v = `150px`

                )->end(
            )->end(
            )->ele( `Label`
                )->a( n = `text`     v = `Input:`
                )->a( n = `labelFor` v = `labeledInputGroup2`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `group` v = `2`

                )->end(
            )->end(
            )->ele( `Input`
                )->a( n = `width`       v = `20%`
                )->a( n = `placeholder` v = `Input`
                )->a( n = `id`          v = `labeledInputGroup2`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `shrinkable` v = `true`
                        )->a( n = `group`      v = `2`
                        )->a( n = `minWidth`   v = `150px`

                )->end(
            )->end(
        )->end(

        )->tag( `MessageStrip`
            )->a( n = `class`    v = `sapUiTinyMargin`
            )->a( n = `text`     v = `Generic Tag controls in Overflow Toolbar`
            )->a( n = `type`     v = `Information`
            )->a( n = `showIcon` v = `true`

        )->ele( `OverflowToolbar`
            )->a( n = `id`    v = `otb10`
            )->a( n = `width` v = width

            )->tag( `Label`
                )->a( n = `text` v = `Multiple Generic Tag instances:`
            )->tag( `ToolbarSpacer`
            )->ele( `GenericTag`
                )->a( n = `text`   v = `Project Cost`
                )->a( n = `design` v = `StatusIconHidden`
                )->a( n = `status` v = `Error`

                )->tag( `ObjectNumber`
                    )->a( n = `state`      v = `Error`
                    )->a( n = `emphasized` v = `false`
                    )->a( n = `number`     v = `3.5M`
                    )->a( n = `unit`       v = `EUR`

            )->end(
            )->tag( `GenericTag`
                )->a( n = `text`   v = `Shortage Expected`
                )->a( n = `status` v = `Warning`
            )->ele( `GenericTag`
                )->a( n = `text`   v = `Project Cost`
                )->a( n = `design` v = `StatusIconHidden`
                )->a( n = `status` v = `Success`

                )->tag( `ObjectNumber`
                    )->a( n = `state`      v = `Success`
                    )->a( n = `emphasized` v = `false`
                    )->a( n = `number`     v = `96`
                    )->a( n = `unit`       v = `%`

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `shrinkable` v = `true`
                        )->a( n = `group`      v = `2`
                        )->a( n = `minWidth`   v = `70px`

                )->end(
            )->end(
            )->tag( `GenericTag`
                )->a( n = `text`   v = `In Stock`
                )->a( n = `status` v = `Success`

        )->end(

        )->tag( `Slider`
            )->a( n = `class` v = `sapUiTinyMarginTopBottom`
            )->a( n = `value` v = client->_bind( viewport ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    viewport = 100.

  ENDMETHOD.

ENDCLASS.
