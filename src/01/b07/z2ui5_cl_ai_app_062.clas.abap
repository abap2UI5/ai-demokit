CLASS z2ui5_cl_ai_app_062 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA default_text        TYPE string.
    DATA error_text          TYPE string.
    DATA warning_text        TYPE string.
    DATA success_text        TYPE string.
    DATA inline_icons_unicode TYPE string.
    DATA inline_icons_helper  TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_062 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`      v = `sap.ui.layout`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `core:require` v = `{Formatter: 'z2ui5/model/formatter'}`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->open( n = `content` ns = `l`
                )->leaf( `MessageStrip`
                    )->a( n = `text`                v = client->_bind( default_text )
                    )->a( n = `enableFormattedText` v = `true`
                    )->a( n = `showIcon`            v = `true`
                    )->a( n = `showCloseButton`     v = `true`
                    )->a( n = `class`               v = `sapUiMediumMarginBottom`
                )->leaf( `MessageStrip`
                    )->a( n = `text`                v = client->_bind( error_text )
                    )->a( n = `type`                v = `Error`
                    )->a( n = `enableFormattedText` v = `true`
                    )->a( n = `showIcon`            v = `true`
                    )->a( n = `showCloseButton`     v = `true`
                    )->a( n = `class`               v = `sapUiMediumMarginBottom`
                )->leaf( `MessageStrip`
                    )->a( n = `text`                v = client->_bind( warning_text )
                    )->a( n = `type`                v = `Warning`
                    )->a( n = `enableFormattedText` v = `true`
                    )->a( n = `showIcon`            v = `true`
                    )->a( n = `showCloseButton`     v = `true`
                    )->a( n = `class`               v = `sapUiMediumMarginBottom`
                )->leaf( `MessageStrip`
                    )->a( n = `text`                v = client->_bind( success_text )
                    )->a( n = `type`                v = `Success`
                    )->a( n = `enableFormattedText` v = `true`
                    )->a( n = `showIcon`            v = `true`
                    )->a( n = `showCloseButton`     v = `true`
                    )->a( n = `class`               v = `sapUiMediumMarginBottom`

                )->open( `MessageStrip`
                    )->a( n = `text`                v = `Information with multiple links %%0 %%1 %%2`
                    )->a( n = `enableFormattedText` v = `true`
                    )->a( n = `showIcon`            v = `true`
                    )->a( n = `showCloseButton`     v = `true`
                    )->a( n = `class`               v = `sapUiMediumMarginBottom`

                    )->open( `controls`
                        )->leaf( `Link`
                            )->a( n = `href` v = `http://www.sap.com`
                            )->a( n = `text` v = `Link 1`
                        )->leaf( `Link`
                            )->a( n = `href` v = `http://www.sap.com`
                            )->a( n = `text` v = `Link 2`
                        )->leaf( `Link`
                            )->a( n = `href` v = `http://www.sap.com`
                            )->a( n = `text` v = `Link 3`

                    )->shut(
                )->shut(

                )->leaf( `MessageStrip`
                    )->a( n = `text`                v = client->_bind( inline_icons_unicode )
                    )->a( n = `type`                v = `Warning`
                    )->a( n = `enableFormattedText` v = `true`
                    )->a( n = `showIcon`            v = `true`
                    )->a( n = `showCloseButton`     v = `true`
                    )->a( n = `class`               v = `sapUiMediumMarginBottom`
                )->leaf( `MessageStrip`
                    )->a( n = `text`                v = `{ path: '/INLINE_ICONS_HELPER', formatter: 'Formatter.expandInlineIcons' }`
                    )->a( n = `type`                v = `Success`
                    )->a( n = `enableFormattedText` v = `true`
                    )->a( n = `showIcon`            v = `true`
                    )->a( n = `showCloseButton`     v = `true`
                    )->a( n = `class`               v = `sapUiMediumMarginBottom` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    default_text = `Default <em>(Information)</em> with default icon and <strong>close button</strong>:`.

    error_text = `<strong>Error</strong> with link to <a target="_blank" href="http://www.sap.com">SAP Homepage</a> <em>(For more info)</em>`.

    warning_text = `<strong>Warning</strong> with default icon and close button:`.

    success_text = `<strong>Success</strong> with default icon and close button:`.

    inline_icons_unicode = `System status: <span class='sapMMsgStripInlineIcon'>&#xe1b4;</span> critical error detected ` &&
                           `<span class='sapMMsgStripInlineIcon'>&#xe049;</span> in module ` &&
                           `<span class='sapMMsgStripInlineIcon'>&#xe126;</span> configuration.`.

    inline_icons_helper = `<strong>Deployment successful!</strong> %%icon:sap-icon://message-success%% All services ` &&
                          `%%icon:sap-icon://sys-enter-2%% are running. <em>Check status</em> ` &&
                          `%%icon:sap-icon://stethoscope%%`.

  ENDMETHOD.

ENDCLASS.
