// https://docs.cypress.io/api/introduction/api.html

describe('RoomsNavigationDrawer Page', () => {
  beforeEach(() => {
    cy.dbReset()
    cy.createLogInUser('test@example.com', 'password')
  })

  describe('複数ルームが登録されている時', () => {
    beforeEach(() => {
      cy.dbUserAssociationCreate(
        'test@example.com',
        'Team',
        {
          name: 'TestTeam'
        }
      )
      cy.dbUserAssociationCreate(
        'test@example.com',
        'Team',
        {
          name: 'OtherTeam'
        }
      )
      cy.dbAssociationCreate(
        'Room',
        {
          name: 'TestRoom2'
        },
        {
          key: 'team',
          model: 'Team',
          params: {
            name: 'TestTeam'
          }
        }
      )
      cy.dbAssociationCreate(
        'Room',
        {
          name: 'TestRoom1'
        },
        {
          key: 'team',
          model: 'Team',
          params: {
            name: 'TestTeam'
          }
        }
      )
      cy.logIn('test@example.com', 'password')
      cy.get('#teams_navigation_drawer').find('.teams').find('.name').eq(0).click()
    })

    describe('ルーム名をクリックした時', () => {
      beforeEach(() => {
        cy.get('#rooms_navigation_drawer').find('.room-groups').find('.room-body').find('.room').eq(0).find('.room-name').click()
      })

      it('ルームに参加できていること', () => {
        cy.get('#rooms_navigation_drawer').find('.room-groups').find('.room-body').find('.room').eq(0).find('.users').find('.user-name').contains('1')
      })

      describe('別のルーム名をクリックした場合', () => {
        beforeEach(() => {
          cy.get('#rooms_navigation_drawer').find('.room-groups').find('.room-body').find('.room').eq(1).find('.room-name').click()
        })

        it('ルームを移動できていること', () => {
          cy.get('#rooms_navigation_drawer').find('.room-groups').find('.room-body').find('.room').eq(0).find('.users').should('not.exist')
          cy.get('#rooms_navigation_drawer').find('.room-groups').find('.room-body').find('.room').eq(1).find('.users').find('.user-name').contains('1')
        })
      })

      describe('別のチームを選択して戻った時', () => {
        beforeEach(() => {
          cy.get('#teams_navigation_drawer').find('.teams').find('.name').eq(1).click()
          cy.get('#teams_navigation_drawer').find('.teams').find('.name').eq(0).click()
        })

        it('ルームに参加していないこと', () => {
          cy.get('#rooms_navigation_drawer').find('.room-groups').find('.room-body').find('.room').eq(0).find('.users').should('not.exist')
          cy.get('#rooms_navigation_drawer').find('.room-groups').find('.room-body').find('.room').eq(1).find('.users').should('not.exist')
        })
      })
    })
  })
})
