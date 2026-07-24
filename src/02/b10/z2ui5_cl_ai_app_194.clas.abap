CLASS z2ui5_cl_ai_app_194 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_person,
        firstname     TYPE string,
        lastname      TYPE string,
        title         TYPE string,
        contactpicurl TYPE string,
        description   TYPE string,
      END OF ty_s_person.
    DATA t_persons TYPE STANDARD TABLE OF ty_s_person WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_194 IMPLEMENTATION.

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
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( n = `Grid` ns = `l`
            )->a( n = `binding`     v = client->_bind( t_persons )
            )->a( n = `class`       v = `sapUiSmallMarginTop`
            )->a( n = `hSpacing`    v = `2`
            )->a( n = `defaultSpan` v = `L6 M6 S10`

            )->open( n = `content` ns = `l`
                )->open( `Image`
                    )->a( n = `src`   v = `{0/CONTACTPICURL}`
                    )->a( n = `width` v = `100%`

                    )->open( `layoutData`
                        )->leaf( n = `GridData` ns = `l`
                            )->a( n = `span`       v = `L3 M3 S8`
                            )->a( n = `linebreakL` v = `true`
                            )->a( n = `linebreakM` v = `true`
                            )->a( n = `linebreakS` v = `true`

                    )->shut(
                )->shut(

                )->open( `VBox`
                    )->leaf( `Text`
                        )->a( n = `text`  v = `{0/FIRSTNAME} {0/LASTNAME}`
                        )->a( n = `class` v = `nameTitle`
                    )->leaf( `Text`
                        )->a( n = `text` v = `{0/DESCRIPTION}`

                )->shut(

                )->open( `Image`
                    )->a( n = `src`   v = `{1/CONTACTPICURL}`
                    )->a( n = `width` v = `100%`

                    )->open( `layoutData`
                        )->leaf( n = `GridData` ns = `l`
                            )->a( n = `span`       v = `L3 M3 S8`
                            )->a( n = `linebreakL` v = `true`
                            )->a( n = `linebreakM` v = `true`
                            )->a( n = `linebreakS` v = `true`

                    )->shut(
                )->shut(

                )->open( `VBox`
                    )->leaf( `Text`
                        )->a( n = `text`  v = `{1/FIRSTNAME} {1/LASTNAME}`
                        )->a( n = `class` v = `nameTitle`
                    )->leaf( `Text`
                        )->a( n = `text` v = `{1/DESCRIPTION}`

                )->shut(

                )->open( `Image`
                    )->a( n = `src`   v = `{2/CONTACTPICURL}`
                    )->a( n = `width` v = `100%`

                    )->open( `layoutData`
                        )->leaf( n = `GridData` ns = `l`
                            )->a( n = `span`       v = `L3 M3 S8`
                            )->a( n = `linebreakL` v = `true`
                            )->a( n = `linebreakM` v = `true`
                            )->a( n = `linebreakS` v = `true`

                    )->shut(
                )->shut(

                )->open( `VBox`
                    )->leaf( `Text`
                        )->a( n = `text`  v = `{2/FIRSTNAME} {2/LASTNAME}`
                        )->a( n = `class` v = `nameTitle`
                    )->leaf( `Text`
                        )->a( n = `text` v = `{2/DESCRIPTION}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " Data of the mock model sap/ui/layout/sample/GridInfo/persons.json used by the original sample
    t_persons = VALUE #(
      ( firstname = `George`
        lastname = `Washington`
        title = `1st U.S. President`
        contactpicurl = `http://upload.wikimedia.org/wikipedia/commons/2/25/George_Washington_as_CIC_of_the_Continental_Army_bust.jpg`
        description = `George Washington was the first President of the United States, the commander-in-chief of the Continental Army during the American Revolutionary War, and one of the Founding Fathers of the United States.` )
      ( firstname = `Alexandrina`
        lastname = `Victoria`
        title = `Former Queen regnant`
        contactpicurl = `http://upload.wikimedia.org/wikipedia/commons/a/aa/Dronning_victoria.jpg`
        description = `Queen Victoria was the monarch of the United Kingdom of Great Britain and Ireland from 20 June 1837 until her death. From 1 May 1876, she used the additional title of Empress of India.` )
      ( firstname = `Friedrich`
        lastname = `Der Große`
        title = `King of Prussia 1740-1786`
        contactpicurl = `http://upload.wikimedia.org/wikipedia/commons/f/fc/Frederic_II_de_prusse.jpg`
        description = `Frederick II was King in Prussia of the Hohenzollern dynasty. He is best known for his brilliance in military campaigning and ` &&
                      `organization of Prussian armies. He became known as Frederick the Great and was nicknamed Der Alte Fritz.` )
      ( firstname = `Agnes`
        lastname = `Teresa`
        title = `Mother Teresa`
        contactpicurl = `http://upload.wikimedia.org/wikipedia/commons/6/6e/The_Saint_Mother_Teresa.jpg`
        description = `Mother Teresa (26 August 1910 – 5 September 1997), was an Albanian born, Indian Roman Catholic Religious Sister. She founded the ` &&
                      `Missionaries of Charity, a Roman Catholic religious congregation, which in 2012 consisted of over 4,500 sisters and is active in 133 countries.` )
      ( firstname = `Sigmund`
        lastname = `Freud`
        title = `Neurologist`
        contactpicurl = `http://upload.wikimedia.org/wikipedia/commons/6/69/Sigmund_Freud_Anciano.jpg`
        description = `Sigmund Freud was an Austrian neurologist who became known as the founding father of psychoanalysis.` )
      ( firstname = `Christopher`
        lastname = `Columbus`
        title = `Explorer`
        contactpicurl = `http://upload.wikimedia.org/wikipedia/commons/0/06/CristobalColon.jpg`
        description = `Christopher Columbus was an Italian explorer, navigator, and colonizer, born in the Republic of Genoa, in what is today northwestern Italy.` )
      ( firstname = `Winston`
        lastname = `Churchill`
        title = `Former Prime Minister of the United Kingdom`
        contactpicurl = `http://upload.wikimedia.org/wikipedia/commons/3/35/Churchill_portrait_NYP_45063.jpg`
        description = `Sir Winston Leonard Spencer-Churchill, KG, OM, CH, TD, DL, FRS, Hon. RA was a British politician who was Prime Minister of the United Kingdom from 1940 to 1945 and again from 1951 to 1955.` ) ).

  ENDMETHOD.

ENDCLASS.
