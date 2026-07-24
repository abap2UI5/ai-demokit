CLASS z2ui5_cl_ai_app_146 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_146 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:c`      v = `sap.ui.core`
        )->a( n = `xmlns:f`      v = `sap.ui.layout.form`
        )->a( n = `displayBlock` v = `true`

        )->open( n = `SimpleForm` ns = `f`
            )->a( n = `layout`          v = `ResponsiveGridLayout`
            )->a( n = `editable`        v = `true`
            )->a( n = `title`           v = `Hyphenation API usage with different languages`
            )->a( n = `adjustLabelSpan` v = `false`
            )->a( n = `labelSpanXL`     v = `1`
            )->a( n = `labelSpanL`      v = `2`
            )->a( n = `labelSpanM`      v = `2`
            )->a( n = `labelSpanS`      v = `4`
            )->leaf( `Label`
                )->a( n = `text` v = `Container Width`
            )->leaf( `Slider`
                )->a( n = `id`         v = `widthSlider`
                )->a( n = `value`      v = `100`
                )->a( n = `liveChange` v = client->_event( `SLIDER` )

        )->shut(

        )->open( `Panel`
            )->a( n = `id`         v = `containerLayout`
            )->a( n = `headerText` v = `Default language (English-US)`
            )->a( n = `width`      v = `100%`
            )->leaf( n = `HTML` ns = `c`
                )->a( n = `id`      v = `hyphenatedText`
                )->a( n = `content` v = ``

        )->shut(
        )->open( `Panel`
            )->a( n = `id`         v = `containerLayoutDE`
            )->a( n = `headerText` v = `German language`
            )->a( n = `width`      v = `100%`
            )->leaf( n = `HTML` ns = `c`
                )->a( n = `id`      v = `hyphenatedTextDE`
                )->a( n = `content` v = ``

        )->shut(
        )->open( `Panel`
            )->a( n = `id`         v = `containerLayoutRU`
            )->a( n = `headerText` v = `Russian language`
            )->a( n = `width`      v = `100%`
            )->leaf( n = `HTML` ns = `c`
                )->a( n = `id`      v = `hyphenatedTextRU`
                )->a( n = `content` v = `` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
