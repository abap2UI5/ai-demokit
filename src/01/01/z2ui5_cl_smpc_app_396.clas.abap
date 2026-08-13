CLASS z2ui5_cl_smpc_app_396 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_396 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->open( `Page`
            )->leaf( n = `InvisibleText` ns = `core`
                )->a( n = `id`   v = `inputLabel`
                )->a( n = `text` v = `Input label`
            )->leaf( `MessageStrip`
                )->a( n = `text`  v = `Left and Right aligned content.`
                )->a( n = `class` v = `sapUiTinyMargin`

            )->open( `OverflowToolbar`
                )->a( n = `class` v = `sapUiMediumMarginTop`

                )->leaf( `Button`
                    )->a( n = `text` v = `Reject`
                    )->a( n = `type` v = `Reject`
                )->leaf( `ToolbarSpacer`
                )->leaf( `Button`
                    )->a( n = `text` v = `Accept`
                    )->a( n = `type` v = `Accept`

            )->shut(

            )->leaf( `MessageStrip`
                )->a( n = `text`  v = `Centered content.`
                )->a( n = `class` v = `sapUiTinyMargin`

            )->open( `OverflowToolbar`
                )->a( n = `class` v = `sapUiMediumMarginTop`

                )->leaf( `ToolbarSpacer`
                )->leaf( `Button`
                    )->a( n = `text` v = `Centered content`
                    )->a( n = `type` v = `Accept`
                )->leaf( `ToolbarSpacer`

            )->shut(

            )->leaf( `MessageStrip`
                )->a( n = `text`  v = `Right Aligned Content.`
                )->a( n = `class` v = `sapUiTinyMargin`

            )->open( `OverflowToolbar`
                )->a( n = `class` v = `sapUiMediumMarginTop`

                )->leaf( `ToolbarSpacer`
                )->leaf( `Button`
                    )->a( n = `text` v = `Right aligned content`
                    )->a( n = `type` v = `Accept`

            )->shut(

            )->leaf( `MessageStrip`
                )->a( n = `text`  v = `You can have as many sections as you want with ToolbarSpacer.`
                )->a( n = `class` v = `sapUiTinyMargin`

            )->open( `OverflowToolbar`
                )->a( n = `class` v = `sapUiMediumMarginTop`

                )->leaf( `Button`
                    )->a( n = `text` v = `Accept`
                    )->a( n = `type` v = `Accept`
                )->leaf( `ToolbarSpacer`
                )->leaf( `CheckBox`
                    )->a( n = `text` v = `CheckBox`
                )->leaf( `ToolbarSpacer`
                )->leaf( `Button`
                    )->a( n = `tooltip` v = `Dropdown`
                    )->a( n = `icon`    v = `sap-icon://drop-down-list`
                )->leaf( `ToolbarSpacer`
                )->leaf( `RadioButton`
                    )->a( n = `text` v = `RadioButton`
                )->leaf( `ToolbarSpacer`
                )->leaf( `Button`
                    )->a( n = `text` v = `Reject`
                    )->a( n = `type` v = `Reject`

            )->shut(

            )->leaf( `MessageStrip`
                )->a( n = `text`
                         v = `Flexible Toolbar Spacers share the free horizontal space equally, thus content centering is not as precise as in Bar.`
                )->a( n = `class` v = `sapUiTinyMargin`

            )->open( `OverflowToolbar`
                )->a( n = `class` v = `sapUiMediumMarginTop`

                )->leaf( `Button`
                    )->a( n = `text` v = `This is a very long button text. This is a very long button text.`
                )->leaf( `ToolbarSpacer`
                )->leaf( `Button`
                    )->a( n = `text` v = `Centered Button`
                )->leaf( `ToolbarSpacer`
                )->leaf( `Button`
                    )->a( n = `text` v = `Short Button`

            )->shut(

            )->leaf( `MessageStrip`
                )->a( n = `text`  v = `ToolbarSpacer does not have to be flexible, a fixed width can be specified too.`
                )->a( n = `class` v = `sapUiTinyMargin`

            )->open( `OverflowToolbar`
                )->a( n = `class` v = `sapUiMediumMarginTop`

                )->leaf( `Input`
                    )->a( n = `ariaLabelledBy` v = `inputLabel`
                    )->a( n = `width`          v = `100px`
                    )->a( n = `placeholder`    v = `First Name`
                )->leaf( `Input`
                    )->a( n = `ariaLabelledBy` v = `inputLabel`
                    )->a( n = `width`          v = `100px`
                    )->a( n = `placeholder`    v = `Last Name`
                )->leaf( `ToolbarSpacer`
                    )->a( n = `width` v = `40px`
                )->leaf( `Input`
                    )->a( n = `ariaLabelledBy` v = `inputLabel`
                    )->a( n = `type`           v = `Email`
                    )->a( n = `width`          v = `100px`
                    )->a( n = `placeholder`    v = `Email`
                )->leaf( `Input`
                    )->a( n = `ariaLabelledBy` v = `inputLabel`
                    )->a( n = `type`           v = `Number`
                    )->a( n = `width`          v = `80px`
                    )->a( n = `placeholder`    v = `Age`
                )->leaf( `ToolbarSpacer`
                )->leaf( `Button`
                    )->a( n = `text` v = `Submit`
                    )->a( n = `type` v = `Accept` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
