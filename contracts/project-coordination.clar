;; Project Coordination Contract
;; This contract coordinates research projects

(define-data-var admin principal tx-sender)

;; Map to store research projects
(define-map projects
  { project-id: (string-ascii 64) }
  {
    title: (string-ascii 100),
    description: (string-ascii 500),
    institution-id: (string-ascii 64),
    lead-researcher: principal,
    start-date: uint,
    end-date: uint,
    status: (string-ascii 20)
  }
)

;; Map to store project collaborators
(define-map project-collaborators
  { project-id: (string-ascii 64), researcher: principal }
  { role: (string-ascii 50), joined-at: uint }
)

;; Public function to create a new project
(define-public (create-project
    (project-id (string-ascii 64))
    (title (string-ascii 100))
    (description (string-ascii 500))
    (institution-id (string-ascii 64))
    (end-date uint))
  (begin
    ;; Check if project already exists
    (asserts! (is-none (map-get? projects { project-id: project-id })) (err u409))

    (ok (map-set projects
      { project-id: project-id }
      {
        title: title,
        description: description,
        institution-id: institution-id,
        lead-researcher: tx-sender,
        start-date: block-height,
        end-date: end-date,
        status: "active"
      }
    ))
  )
)

;; Public function to add a collaborator to a project
(define-public (add-collaborator
    (project-id (string-ascii 64))
    (researcher principal)
    (role (string-ascii 50)))
  (begin
    ;; Check if project exists and sender is lead researcher
    (match (map-get? projects { project-id: project-id })
      project (begin
        (asserts! (is-eq (get lead-researcher project) tx-sender) (err u403))
        (ok (map-set project-collaborators
          { project-id: project-id, researcher: researcher }
          { role: role, joined-at: block-height }
        ))
      )
      (err u404)
    )
  )
)

;; Public function to update project status
(define-public (update-project-status
    (project-id (string-ascii 64))
    (new-status (string-ascii 20)))
  (begin
    ;; Check if project exists and sender is lead researcher
    (match (map-get? projects { project-id: project-id })
      project (begin
        (asserts! (is-eq (get lead-researcher project) tx-sender) (err u403))
        (ok (map-set projects
          { project-id: project-id }
          (merge project { status: new-status })
        ))
      )
      (err u404)
    )
  )
)

;; Read-only function to get project details
(define-read-only (get-project (project-id (string-ascii 64)))
  (map-get? projects { project-id: project-id })
)

;; Read-only function to check if a researcher is a collaborator
(define-read-only (is-collaborator (project-id (string-ascii 64)) (researcher principal))
  (is-some (map-get? project-collaborators { project-id: project-id, researcher: researcher }))
)
