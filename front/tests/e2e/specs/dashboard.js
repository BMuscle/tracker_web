// https://docs.cypress.io/api/introduction/api.html

describe('Dashboard Page', () => {
  beforeEach(() => {
    cy.dbReset()
    cy.createLogInUser('test@example.com', 'password')
  })

  describe('ログインした時', () => {
    beforeEach(() => {
      cy.logIn('test@example.com', 'password')
    })

    it('ダッシュボード画面へ遷移していること', () => {
      cy.location().should((loc) => {
        expect(loc.pathname).to.eq('/dashboard')
      })
    })
  })

  describe('ログインしていない時', () => {
    beforeEach(() => {
      cy.visit('/dashboard')
    })
    it('ログイン画面へリダイレクトしていること', () => {
      cy.location().should((loc) => {
        expect(loc.pathname).to.eq('/log_in')
      })
    })
  })
})
