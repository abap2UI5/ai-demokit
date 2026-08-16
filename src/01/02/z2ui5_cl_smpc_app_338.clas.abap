" @keywords fixflex fix flex sap.ui.layout fixflexfixedsize scrollcontainer text
" @summary Shows a FixFlex control where fixContentSize is set to a specific value(200px) and sap.m.scrollContainer is enabling vertical scrolling.
CLASS z2ui5_cl_smpc_app_338 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_338 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `height`    v = `100%`

        )->ele( n = `FixFlex` ns = `l`
            )->a( n = `class`          v = `fixFlexFixedSize`
            )->a( n = `fixContentSize` v = `150px`

            )->ele( n = `fixContent` ns = `l`
                )->ele( `ScrollContainer`
                    )->a( n = `height`   v = `100%`
                    )->a( n = `vertical` v = `true`

                    )->tag( `Text`
                        )->a( n = `text` v = `Fix content - Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever ` &&
                                         `since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries,` &&
                                         ` but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets ` &&
                                         `containing.`
                    )->tag( `Text`
                        )->a( n = `text` v = `Fix content - Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever ` &&
                                         `since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries,` &&
                                         ` but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets ` &&
                                         `containing.`
                    )->tag( `Text`
                        )->a( n = `text` v = `Fix content - Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever ` &&
                                         `since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries,` &&
                                         ` but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets ` &&
                                         `containing.`
                    )->tag( `Text`
                        )->a( n = `text` v = `Fix content - Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever ` &&
                                         `since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries,` &&
                                         ` but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets ` &&
                                         `containing.`

                )->end(
            )->end(
            )->ele( n = `flexContent` ns = `l`
                )->tag( `Text`
                    )->a( n = `class` v = `column1`
                    )->a( n = `text`  v = `This container is flexible and it will adapt its size to fill the remaining size in the FixFlex control` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
