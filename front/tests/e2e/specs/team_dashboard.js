// https://docs.cypress.io/api/introduction/api.html

describe('TeamDashboard Page', () => {
  beforeEach(() => {
    cy.dbReset()
    cy.createLogInUser('test@example.com', 'password')
  })

  describe('招待URL参加', () => {
    beforeEach(() => {
      cy.createLogInUser('other@example.com', 'password')
      cy.dbUserAssociationCreate(
        'other@example.com',
        'Team',
        {
          name: 'OtherTeam'
        }
      )
    })

    describe('正しい招待URLの場合', () => {
      beforeEach(() => {
        cy.logIn('other@example.com', 'password')
        cy.get('#teams_navigation_drawer').find('.teams').find('.name').click()
        cy.get('#team_dashboard').find('.create-invite-url').click()
        cy.get('#team_dashboard').find('.invite-url-copy-button').click()
        cy.task('getClipboard').then((clipboard) => {
          cy.logOut()
          cy.logIn('test@example.com', 'password')
          cy.visit(clipboard)
        })
      })

      it('チームが追加され通知もされていること', () => {
        cy.get('#team_dashboard').contains('name: OtherTeam')
        cy.get('#team_dashboard').contains('expired? false')
        cy.get('#toast').contains('参加に成功しました。')
      })

      describe('既に参加済みのチームの場合', () => {
        beforeEach(() => {
          cy.task('getClipboard').then((clipboard) => {
            cy.visit(clipboard)
          })
        })

        it('チームが表示され既に参加しているという旨の通知もされていること', () => {
          cy.get('#team_dashboard').contains('name: OtherTeam')
          cy.get('#team_dashboard').contains('expired? false')
          cy.get('#toast').contains('既に参加しています。')
        })
      })
    })

    describe('ログインユーザが登録したチームの場合', () => {
      beforeEach(() => {
        cy.logIn('other@example.com', 'password')
        cy.get('#teams_navigation_drawer').find('.teams').find('.name').click()
        cy.get('#team_dashboard').find('.create-invite-url').click()
        cy.get('#team_dashboard').find('.invite-url-copy-button').click()
        cy.task('getClipboard').then((clipboard) => {
          cy.visit(clipboard)
        })
      })

      it('チームが表示され既に参加しているという旨の通知もされていること', () => {
        cy.get('#team_dashboard').contains('name: OtherTeam')
        cy.get('#team_dashboard').contains('expired? false')
        cy.get('#toast').contains('既に参加しています。')
      })
    })

    describe('存在しない招待URLの場合', () => {
      beforeEach(() => {
        cy.logIn('test@example.com', 'password')
        cy.visit('/teams/invites/confirm?guid=xxxxxxxxx')
      })

      it('参加に失敗しました。と表示されること', () => {
        cy.get('#toast').contains('参加に失敗しました。')
      })
    })

    describe('期限切れの招待URLの場合', () => {
      beforeEach(() => {
        cy.dbUserAssociationCreate(
          'other@example.com',
          'Team',
          {
            name: 'ExpiredTeam',
            invite_guid: 'test-guid',
            invite_expired: '2020-01-01T00:00:00'
          }
        )
        cy.logIn('test@example.com', 'password')
        cy.visit('/teams/invites/confirm?guid=test-guid')
      })

      it('期限切れですと表示されること', () => {
        cy.get('#toast').contains('招待用URLが期限切れです。')
      })
    })

    describe('ログインしていない時', () => {
      beforeEach(() => {
        cy.visit('/teams/invites/confirm?guid=xxxxxxxxx')
      })

      it('ログイン画面にリダイレクトすること', () => {
        cy.url().should('include', '/log_in')
      })
    })
  })
})
