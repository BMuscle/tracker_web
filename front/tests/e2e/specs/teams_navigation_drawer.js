// https://docs.cypress.io/api/introduction/api.html

describe('TeamsNavigationDrawer Page', () => {
  beforeEach(() => {
    cy.dbReset()
    cy.createLogInUser('test@example.com', 'password')
  })

  describe('ログインした時', () => {
    beforeEach(() => {
      cy.logIn('test@example.com', 'password')
    })

    describe('チームを登録した時', () => {
      beforeEach(() => {
        cy.get('#create_team_button').click()
        const createTeamForm = cy.get('#teams_navigation_drawer').get('#create_team_form')
        createTeamForm.get('input[name=team_name]').type('テストチーム')
        createTeamForm.get('.create-team-submit').click()
      })
      it('チームが追加され表示されていること', () => {
        cy.get('#team_dashboard').contains('name: テストチーム')
      })
    })
  })
})

// まず、クリップボード
// 次は、招待URL作成のテストを作る
// 最後にJenkinsFileにChrome
