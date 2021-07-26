// https://docs.cypress.io/api/introduction/api.html

describe('Home Page', () => {
  beforeEach(() => {
    cy.dbReset()
    cy.createLogInUser('test@example.com', 'password')
  })

  describe('ログインした時', () => {
    beforeEach(() => {
      cy.logIn('test@example.com', 'password')
      cy.visit('/')
    })

    it('ナビゲーションバーがログイン状態用の表示になっていること', () => {
      cy.get('#public_navigation_bar').contains('button', 'ログアウト')
      cy.get('#public_navigation_bar').contains('button', 'ダッシュボード')
      cy.get('#public_navigation_bar').contains('button', 'ログイン').should('not.exist')
      cy.get('#public_navigation_bar').contains('button', 'アカウント登録').should('not.exist')
    })
  })

  describe('ログインしていない時', () => {
    beforeEach(() => {
      cy.visit('/')
    })
    it('ナビゲーションばーがログアウト状態用の表示になっていること', () => {
      cy.get('#public_navigation_bar').contains('button', 'ログイン')
      cy.get('#public_navigation_bar').contains('button', 'アカウント登録')
      cy.get('#public_navigation_bar').contains('button', 'ログアウト').should('not.exist')
      cy.get('#public_navigation_bar').contains('button', 'ダッシュボード').should('not.exist')
    })
  })
})
