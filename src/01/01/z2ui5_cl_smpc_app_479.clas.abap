" @keywords combobox combo box sap.m comboboxsearchboth verticallayout listitem label text
" @summary Combo box dropdown list with search functionality which checks both columns. When you need to display additional information on your options, like e.g. keys of countries or system abbreviations, and want to search in those as well.
CLASS z2ui5_cl_smpc_app_479 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_country,
             key  TYPE string,
             text TYPE string,
           END OF ty_s_country.
    TYPES ty_t_country TYPE STANDARD TABLE OF ty_s_country WITH DEFAULT KEY.

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
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

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
                        )->a( n = `items`                 v = |\{ path: '{ client->_bind_path( t_countries ) }', sorter: \{ path: 'TEXT' \} \}|

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
      DATA temp1 TYPE string.

    IF client->get_event( ) = `CHANGE`.

      " fnFormatter: "text (key)" when both are there, otherwise whichever one is
      
      IF combo_box_value IS NOT INITIAL AND combo_box_key IS NOT INITIAL.
        temp1 = |{ combo_box_value } ({ combo_box_key })|.
      ELSEIF combo_box_value IS NOT INITIAL.
        temp1 = combo_box_value.
      ELSEIF combo_box_key IS NOT INITIAL.
        temp1 = combo_box_key.
      ELSE.
        temp1 = ``.
      ENDIF.
      formatted = temp1.

    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " full mock /CountriesCollection of ui5/mock/countriesExtendedCollection.json
    DATA temp2 TYPE z2ui5_cl_smpc_app_479=>ty_t_country.
    DATA temp3 LIKE LINE OF temp2.
    CLEAR temp2.
    
    temp3-key = `DZ`.
    temp3-text = `Algeria`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `AR`.
    temp3-text = `Argentina`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `AU`.
    temp3-text = `Australia`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `AT`.
    temp3-text = `Austria`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `BH`.
    temp3-text = `Bahrain`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `BE`.
    temp3-text = `Belgium`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `BA`.
    temp3-text = `Bosnia and Herzegovina`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `BR`.
    temp3-text = `Brazil`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `BG`.
    temp3-text = `Bulgaria`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `CA`.
    temp3-text = `Canada`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `CL`.
    temp3-text = `Chile`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `CO`.
    temp3-text = `Colombia`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `HR`.
    temp3-text = `Croatia`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `CU`.
    temp3-text = `Cuba`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `CZ`.
    temp3-text = `Czech Republic`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `DK`.
    temp3-text = `Denmark`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `EG`.
    temp3-text = `Egypt`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `EE`.
    temp3-text = `Estonia`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `FI`.
    temp3-text = `Finland`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `FR`.
    temp3-text = `France`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `GER`.
    temp3-text = `Germany`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `GH`.
    temp3-text = `Ghana`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `GR`.
    temp3-text = `Greece`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `HU`.
    temp3-text = `Hungary`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `IN`.
    temp3-text = `India`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `ID`.
    temp3-text = `Indonesia`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `IE`.
    temp3-text = `Ireland`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `IL`.
    temp3-text = `Israel`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `IT`.
    temp3-text = `Italy`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `JP`.
    temp3-text = `Japan`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `JO`.
    temp3-text = `Jordan`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `KE`.
    temp3-text = `Kenya`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `KW`.
    temp3-text = `Kuwait`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `LV`.
    temp3-text = `Latvia`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `LT`.
    temp3-text = `Lithuania`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `MK`.
    temp3-text = `Macedonia`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `MY`.
    temp3-text = `Malaysia`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `MX`.
    temp3-text = `Mexico`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `ME`.
    temp3-text = `Montenegro`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `MA`.
    temp3-text = `Morocco`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `NL`.
    temp3-text = `Netherlands`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `NZ`.
    temp3-text = `New Zealand`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `NG`.
    temp3-text = `Nigeria`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `NO`.
    temp3-text = `Norway`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `OM`.
    temp3-text = `Oman`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `PE`.
    temp3-text = `Peru`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `PH`.
    temp3-text = `Philippines`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `PL`.
    temp3-text = `Poland`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `PT`.
    temp3-text = `Portugal`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `QA`.
    temp3-text = `Qatar`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `RO`.
    temp3-text = `Romania`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `RU`.
    temp3-text = `Russia`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `SA`.
    temp3-text = `Saudi Arabia`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `SN`.
    temp3-text = `Senegal`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `RS`.
    temp3-text = `Serbia`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `SG`.
    temp3-text = `Singapore`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `SK`.
    temp3-text = `Slovakia`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `SI`.
    temp3-text = `Slovenia`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `ZA`.
    temp3-text = `South Africa`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `KR`.
    temp3-text = `South Korea`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `ES`.
    temp3-text = `Spain`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `SE`.
    temp3-text = `Sweden`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `CH`.
    temp3-text = `Switzerland`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `TN`.
    temp3-text = `Tunisia`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `TR`.
    temp3-text = `Turkey`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `UG`.
    temp3-text = `Uganda`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `UA`.
    temp3-text = `Ukraine`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `AE`.
    temp3-text = `United Arab Emirates`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `GB`.
    temp3-text = `United Kingdom`.
    INSERT temp3 INTO TABLE temp2.
    temp3-key = `YE`.
    temp3-text = `Yemen`.
    INSERT temp3 INTO TABLE temp2.
    t_countries = temp2.

  ENDMETHOD.

ENDCLASS.
