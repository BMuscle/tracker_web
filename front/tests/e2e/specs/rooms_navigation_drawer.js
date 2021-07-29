// https://docs.cypress.io/api/introduction/api.html

describe('RoomsNavigationDrawer Page', () => {
  beforeEach(() => {
    cy.dbReset()
    cy.createLogInUser('test@example.com', 'password')
  })

  describe('管理しているチームのルームが登録されている時', () => {
    beforeEach(() => {
      cy.dbUserAssociationCreate(
        'test@example.com',
        'Team',
        {
          name: 'TestTeam'
        }
      )
      cy.dbAssociationCreate(
        'Room',
        {
          name: 'TestRoom'
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
      cy.get('#teams_navigation_drawer').find('.teams').find('.name').click()
    })
    it('ルームが表示されていること', () => {
      cy.get('#rooms_navigation_drawer').find('.room-groups').find('.room-body').contains('.name', 'TestRoom')
    })
  })

  describe('参加しているチームのルームが登録されている時', () => {
    beforeEach(() => {
      cy.createLogInUser('other@example.com', 'password')
      cy.dbUserAssociationCreate(
        'other@example.com',
        'Team',
        {
          name: 'OtherTestTeam'
        }
      )
      cy.dbAssociationCreate(
        'Room',
        {
          name: 'TestRoom'
        },
        {
          key: 'team',
          model: 'Team',
          params: {
            name: 'OtherTestTeam'
          }
        }
      )
      cy.dbAssociationCreate(
        'TeamUser',
        {},
        [
          {
            key: 'team',
            model: 'Team',
            params: {
              name: 'OtherTestTeam'
            }
          },
          {
            key: 'user',
            model: 'User',
            params: {
              email: 'test@example.com'
            }
          }
        ]
      )
      cy.logIn('test@example.com', 'password')
      cy.get('#teams_navigation_drawer').find('.teams').find('.name').click()
    })
    it('ルームが表示されていること', () => {
      cy.get('#rooms_navigation_drawer').find('.room-groups').find('.room-body').contains('.name', 'TestRoom')
    })
  })

  describe('チームを表示した状態で別のチームを選択した時', () => {
    beforeEach(() => {
      cy.dbUserAssociationCreate(
        'test@example.com',
        'Team',
        {
          name: 'TestTeam1'
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
            name: 'TestTeam1'
          }
        }
      )
      cy.dbUserAssociationCreate(
        'test@example.com',
        'Team',
        {
          name: 'TestTeam2'
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
            name: 'TestTeam2'
          }
        }
      )

      cy.logIn('test@example.com', 'password')
      cy.get('#teams_navigation_drawer').find('.teams').find('.name').eq(0).click()
    })
    it('別のチームのルームが表示されていること', () => {
      cy.get('#rooms_navigation_drawer').find('.room-groups').find('.room-body').contains('.name', 'TestRoom1')
      cy.get('#teams_navigation_drawer').find('.teams').find('.name').eq(1).click()
    })
  })

  describe('ルームが登録されていない時', () => {
    beforeEach(() => {
      cy.dbUserAssociationCreate(
        'test@example.com',
        'Team',
        {
          name: 'TestTeam'
        }
      )
      cy.logIn('test@example.com', 'password')
      cy.get('#teams_navigation_drawer').find('.teams').find('.name').click()
    })
    it('ルームが空で表示されていること', () => {
      cy.get('#rooms_navigation_drawer').find('.room-groups').contains('.room-title', 'ルーム')
      cy.get('#rooms_navigation_drawer').find('.room-groups').find('.room-body').find('.name').should('not.exist')
    })
  })
  describe('チームが登録されていない時', () => {
    beforeEach(() => {
      cy.logIn('test@example.com', 'password')
    })
    it('ルームが表示されていないこと', () => {
      cy.get('#rooms_navigation_drawer').find('.room-groups').should('not.exist')
    })
  })

  describe('ルームを登録した時', () => {
    beforeEach(() => {
      cy.dbUserAssociationCreate(
        'test@example.com',
        'Team',
        {
          name: 'TestTeam'
        }
      )
      cy.logIn('test@example.com', 'password')
      cy.get('#teams_navigation_drawer').find('.teams').find('.name').click()
      cy.get('#rooms_navigation_drawer').find('.open-create-room-button').click()
      const createRoomForm = cy.get('#create_room_form')
      createRoomForm.get('input[name=room_name]').type('テストルーム')
      createRoomForm.get('.create-room-submit').click()
    })
    it('ルームが登録され表示されていること', () => {
      cy.get('#rooms_navigation_drawer').find('.room-groups').find('.room-body').contains('.name', 'テストルーム')
    })
  })
})
