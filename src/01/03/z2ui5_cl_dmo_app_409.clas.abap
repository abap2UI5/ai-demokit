CLASS z2ui5_cl_dmo_app_409 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_409 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " Block->content inlining (app 161/178/261 precedent): the blocks aggregation
    " holds the custom BlockBase blockinblock:Block (mode 'Collapsed'), whose view
    " instantiates a second BlockBase sample:InnerBlock - the block-in-block point.
    " Both block views are pure html divs, rendered below as one core:HTML; the
    " two ModelMapping config elements are dropped (see sidecar IMPROVISED).
    view->open( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.uxap`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( `ObjectPageLayout`
            )->a( n = `id`                 v = `ObjectPageLayout`
            )->a( n = `upperCaseAnchorBar` v = `false`

            )->open( `headerTitle`
                )->leaf( `ObjectPageHeader`
                    )->a( n = `objectTitle` v = `Block in Block`

            )->shut(

            )->open( `sections`
                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `example`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Example`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`
                                )->leaf( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:24em; background-color: #A9EAFF ;">` &&
                                                            `<div style="height:16em; background-color: blue ; margin:1em"></div></div>` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
