CLASS z2ui5_cl_dmo_app_408 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA subsectionlayout TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_408 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      subsectionlayout = `TitleOnTop`.
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " Block->content inlining (app 161/178 precedent): the blocks aggregations
    " hold SharedBlocks BlockBase controls (blockcolor:BlockBlue and
    " blockcolor:BlockBlueWithInfo), each a lazy-loading wrapper around a
    " static view - inlined below as core:HTML leaves (+ one m:Text). The
    " controller's named ConfigModel is folded onto the default model root
    " (app 230 precedent, see sidecar).
    view->open( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.uxap`
        )->a( n = `xmlns:m`    v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( `ObjectPageLayout`
            )->a( n = `id`                 v = `ObjectPageLayout`
            )->a( n = `subSectionLayout`   v = client->_bind( subsectionlayout )
            )->a( n = `upperCaseAnchorBar` v = `false`

            )->open( `headerTitle`
                )->open( `ObjectPageHeader`
                    )->a( n = `objectTitle` v = `ObjectPage BlockBase`

                    )->open( `actions`
                        )->leaf( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`    v = `sap-icon://synchronize`
                            )->a( n = `press`   v = client->_event( `TOGGLE_TITLE` )
                            )->a( n = `text`    v = `toggle title`
                            )->a( n = `tooltip` v = `synchronize`

                    )->shut(
                )->shut(
            )->shut(

            )->open( `sections`
                )->open( `ObjectPageSection`
                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Blocks with columnLayout 1`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`
                                )->leaf( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:4em; background-color: #A9EAFF ;"></div>`
                                )->leaf( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:4em; background-color: #A9EAFF ;"></div>`
                                )->leaf( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:4em; background-color: #A9EAFF ;"></div>`

                            )->shut(
                        )->shut(

                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Blocks with columnLayout 2`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`
                                )->leaf( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:auto;min-height:4em; background-color: #A9EAFF ;line-height: 4em;">` &&
                                                            `<a>ShowSubsectionMore = true</a><br/></div>`
                                " moreContentText stays empty - the BlockBase Expanded mode that
                                " fills it is dropped with the block control (see sidecar)
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `id` v = `moreContentText`
                                )->leaf( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:4em; background-color: #A9EAFF ;"></div>`

                            )->shut(
                        )->shut(

                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Blocks with columnLayout 3`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`
                                )->leaf( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:4em; background-color: #A9EAFF ;"></div>`
                                )->leaf( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:4em; background-color: #A9EAFF ;"></div>`
                                )->leaf( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:4em; background-color: #A9EAFF ;"></div>` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `TOGGLE_TITLE`.
        subsectionlayout = COND #( WHEN subsectionlayout = `TitleOnTop`
                                   THEN `TitleOnLeft`
                                   ELSE `TitleOnTop` ).
        client->view_model_update( ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
