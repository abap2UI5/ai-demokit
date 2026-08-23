" @keywords hyphenation sap.ui.core.hyphenation api html simpleform label slider panel
" @summary This sample demonstrates usage of the Hyphenation API
CLASS z2ui5_cl_smpc_app_146 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA slider_value TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_146 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " the original's onSliderMoved sets the three Panel widths to value + "%" in
    " JS; rebuilt as a two-way bound Slider value plus an expression binding on
    " each Panel width, so the resize runs on the client with no round-trip
    " (thin frontend) and the liveChange wire is not needed
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:c`      v = `sap.ui.core`
        )->a( n = `xmlns:f`      v = `sap.ui.layout.form`
        )->a( n = `displayBlock` v = `true`

        )->ele( n = `SimpleForm` ns = `f`
            )->a( n = `layout`          v = `ResponsiveGridLayout`
            )->a( n = `editable`        v = `true`
            )->a( n = `title`           v = `Hyphenation API usage with different languages`
            )->a( n = `adjustLabelSpan` v = `false`
            )->a( n = `labelSpanXL`     v = `1`
            )->a( n = `labelSpanL`      v = `2`
            )->a( n = `labelSpanM`      v = `2`
            )->a( n = `labelSpanS`      v = `4`
            )->tag( `Label`
                )->a( n = `text` v = `Container Width`
            )->tag( `Slider`
                )->a( n = `id`    v = `widthSlider`
                )->a( n = `value` v = client->_bind( slider_value )

        )->end(

        )->ele( `Panel`
            )->a( n = `id`         v = `containerLayout`
            )->a( n = `headerText` v = `Default language (English-US)`
            )->a( n = `width`      v = |\{= ${ client->_bind( slider_value ) } + '%' \}|
            )->tag( n = `HTML` ns = `c`
                )->a( n = `id`      v = `hyphenatedText`
                )->a( n = `content` v = ``

        )->end(
        )->ele( `Panel`
            )->a( n = `id`         v = `containerLayoutDE`
            )->a( n = `headerText` v = `German language`
            )->a( n = `width`      v = |\{= ${ client->_bind( slider_value ) } + '%' \}|
            )->tag( n = `HTML` ns = `c`
                )->a( n = `id`      v = `hyphenatedTextDE`
                )->a( n = `content` v = ``

        )->end(
        )->ele( `Panel`
            )->a( n = `id`         v = `containerLayoutRU`
            )->a( n = `headerText` v = `Russian language`
            )->a( n = `width`      v = |\{= ${ client->_bind( slider_value ) } + '%' \}|
            )->tag( n = `HTML` ns = `c`
                )->a( n = `id`      v = `hyphenatedTextRU`
                )->a( n = `content` v = `` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the original Slider carries value="100" and the Panels width="100%"
    slider_value = 100.

  ENDMETHOD.

ENDCLASS.
