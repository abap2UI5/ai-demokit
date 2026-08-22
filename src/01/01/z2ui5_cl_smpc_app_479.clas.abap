" @keywords combobox combo box sap.m comboboxsearchboth label text
" @summary Combo box dropdown list with search functionality which checks both columns. When you need to display additional information on your options, like e.g. keys of countries or system abbreviations, and want to search in those as well.
CLASS z2ui5_cl_smpc_app_479 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_country,
             key  TYPE string,
             text TYPE string,
           END OF ty_s_country.
    TYPES ty_t_country TYPE STANDARD TABLE OF ty_s_country WITH EMPTY KEY.

    DATA t_countries TYPE ty_t_country.

    DATA combo_box_value TYPE string.
    DATA combo_box_key   TYPE string.
    DATA formatted       TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_479 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `Page`
            )->a( n = `showHeader` v = `false`
            )->a( n = `class`      v = `sapUiContentPadding`

            )->ele( `content`
                )->ele( n = `VerticalLayout` ns = `l`

                    )->ele( `ComboBox`
                        )->a( n = `id`                    v = `idComboBox`
                        )->a( n = `showSecondaryValues`   v = `true`
                        )->a( n = `filterSecondaryValues` v = `true`
                        )->a( n = `value`                 v = client->_bind( combo_box_value )
                        )->a( n = `selectedKey`           v = client->_bind( combo_box_key )
                        " fnFormatter joins value and key - a formatter is business logic,
                        " so the text is composed in ABAP; the change wire is what tells
                        " the backend to recompute it
                        )->a( n = `change`                v = client->_event( `CHANGE` )
                        )->a( n = `items`                 v = |\{ path: '{ client->_bind( val = t_countries path = abap_true ) }', sorter: \{ path: 'TEXT' \} \}|

                        )->tag( n = `ListItem` ns = `core`
                            )->a( n = `key`            v = `{KEY}`
                            )->a( n = `text`           v = `{TEXT}`
                            )->a( n = `additionalText` v = `{KEY}`

                    )->end(

                    )->tag( `Label`
                        )->a( n = `text`     v = `Formatted value (text and key):`
                        )->a( n = `labelFor` v = `idComboBox`
                    )->tag( `Text`
                        )->a( n = `text` v = client->_bind( formatted ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `CHANGE`.

      " fnFormatter: "text (key)" when both are there, otherwise whichever one is
      formatted = COND string( WHEN combo_box_value IS NOT INITIAL AND combo_box_key IS NOT INITIAL
                               THEN |{ combo_box_value } ({ combo_box_key })|
                               WHEN combo_box_value IS NOT INITIAL THEN combo_box_value
                               WHEN combo_box_key IS NOT INITIAL THEN combo_box_key
                               ELSE `` ).

    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " full mock /CountriesCollection of ui5/mock/countriesExtendedCollection.json
    t_countries = VALUE #(
        ( key = `DZ` text = `Algeria` )
        ( key = `AR` text = `Argentina` )
        ( key = `AU` text = `Australia` )
        ( key = `AT` text = `Austria` )
        ( key = `BH` text = `Bahrain` )
        ( key = `BE` text = `Belgium` )
        ( key = `BA` text = `Bosnia and Herzegovina` )
        ( key = `BR` text = `Brazil` )
        ( key = `BG` text = `Bulgaria` )
        ( key = `CA` text = `Canada` )
        ( key = `CL` text = `Chile` )
        ( key = `CO` text = `Colombia` )
        ( key = `HR` text = `Croatia` )
        ( key = `CU` text = `Cuba` )
        ( key = `CZ` text = `Czech Republic` )
        ( key = `DK` text = `Denmark` )
        ( key = `EG` text = `Egypt` )
        ( key = `EE` text = `Estonia` )
        ( key = `FI` text = `Finland` )
        ( key = `FR` text = `France` )
        ( key = `GER` text = `Germany` )
        ( key = `GH` text = `Ghana` )
        ( key = `GR` text = `Greece` )
        ( key = `HU` text = `Hungary` )
        ( key = `IN` text = `India` )
        ( key = `ID` text = `Indonesia` )
        ( key = `IE` text = `Ireland` )
        ( key = `IL` text = `Israel` )
        ( key = `IT` text = `Italy` )
        ( key = `JP` text = `Japan` )
        ( key = `JO` text = `Jordan` )
        ( key = `KE` text = `Kenya` )
        ( key = `KW` text = `Kuwait` )
        ( key = `LV` text = `Latvia` )
        ( key = `LT` text = `Lithuania` )
        ( key = `MK` text = `Macedonia` )
        ( key = `MY` text = `Malaysia` )
        ( key = `MX` text = `Mexico` )
        ( key = `ME` text = `Montenegro` )
        ( key = `MA` text = `Morocco` )
        ( key = `NL` text = `Netherlands` )
        ( key = `NZ` text = `New Zealand` )
        ( key = `NG` text = `Nigeria` )
        ( key = `NO` text = `Norway` )
        ( key = `OM` text = `Oman` )
        ( key = `PE` text = `Peru` )
        ( key = `PH` text = `Philippines` )
        ( key = `PL` text = `Poland` )
        ( key = `PT` text = `Portugal` )
        ( key = `QA` text = `Qatar` )
        ( key = `RO` text = `Romania` )
        ( key = `RU` text = `Russia` )
        ( key = `SA` text = `Saudi Arabia` )
        ( key = `SN` text = `Senegal` )
        ( key = `RS` text = `Serbia` )
        ( key = `SG` text = `Singapore` )
        ( key = `SK` text = `Slovakia` )
        ( key = `SI` text = `Slovenia` )
        ( key = `ZA` text = `South Africa` )
        ( key = `KR` text = `South Korea` )
        ( key = `ES` text = `Spain` )
        ( key = `SE` text = `Sweden` )
        ( key = `CH` text = `Switzerland` )
        ( key = `TN` text = `Tunisia` )
        ( key = `TR` text = `Turkey` )
        ( key = `UG` text = `Uganda` )
        ( key = `UA` text = `Ukraine` )
        ( key = `AE` text = `United Arab Emirates` )
        ( key = `GB` text = `United Kingdom` )
        ( key = `YE` text = `Yemen` ) ).

  ENDMETHOD.

ENDCLASS.
