" @keywords blockbase block base sap.uxap objectpageblockbase objectpagelayout objectpageheader objectpageheaderactionbutton objectpagesection objectpagesubsection html text
" @summary This example shows the different layout of the blocks based on their ColumnLayout.
CLASS z2ui5_cl_smpc_app_408 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA subsectionlayout TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_408 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      subsectionlayout = `TitleOnTop`.
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " Block->content inlining (app 161/178 precedent): the blocks aggregations
    " hold SharedBlocks BlockBase controls (blockcolor:BlockBlue and
    " blockcolor:BlockBlueWithInfo), each a lazy-loading wrapper around a
    " static view - inlined below as core:HTML leaves (+ one m:Text). The
    " controller's named ConfigModel is folded onto the default model root
    " (app 230 precedent, see sidecar).
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.uxap`
        )->a( n = `xmlns:m`    v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                 v = `ObjectPageLayout`
            )->a( n = `subSectionLayout`   v = client->_bind( subsectionlayout )
            )->a( n = `upperCaseAnchorBar` v = `false`

            )->ele( `headerTitle`
                )->ele( `ObjectPageHeader`
                    )->a( n = `objectTitle` v = `ObjectPage BlockBase`

                    )->ele( `actions`
                        )->tag( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`    v = `sap-icon://synchronize`
                            )->a( n = `press`   v = client->_event( `TOGGLE_TITLE` )
                            )->a( n = `text`    v = `toggle title`
                            )->a( n = `tooltip` v = `synchronize`

                    )->end(
                )->end(
            )->end(

            )->ele( `sections`
                )->ele( `ObjectPageSection`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Blocks with columnLayout 1`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`
                                )->tag( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:4em; background-color: #A9EAFF ;"></div>`
                                )->tag( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:4em; background-color: #A9EAFF ;"></div>`
                                )->tag( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:4em; background-color: #A9EAFF ;"></div>`

                            )->end(
                        )->end(

                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Blocks with columnLayout 2`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`
                                )->tag( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:auto;min-height:4em; background-color: #A9EAFF ;line-height: 4em;">` &&
                                                            `<a>ShowSubsectionMore = true</a><br/></div>`
                                " moreContentText stays empty - the BlockBase Expanded mode that
                                " fills it is dropped with the block control (see sidecar)
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `id` v = `moreContentText`
                                )->tag( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:4em; background-color: #A9EAFF ;"></div>`

                            )->end(
                        )->end(

                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Blocks with columnLayout 3`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`
                                )->tag( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:4em; background-color: #A9EAFF ;"></div>`
                                )->tag( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:4em; background-color: #A9EAFF ;"></div>`
                                )->tag( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:4em; background-color: #A9EAFF ;"></div>` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `TOGGLE_TITLE`.
      subsectionlayout = COND #( WHEN subsectionlayout = `TitleOnTop` THEN `TitleOnLeft` ELSE `TitleOnTop` ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
