;; Progress Tracking Contract
;; This contract tracks research project progress

;; Map to store project milestones
(define-map milestones
  { project-id: (string-ascii 64), milestone-id: (string-ascii 64) }
  {
    title: (string-ascii 100),
    description: (string-ascii 500),
    due-date: uint,
    completed: bool,
    completion-date: (optional uint)
  }
)

;; Map to store project updates
(define-map project-updates
  { project-id: (string-ascii 64), update-id: (string-ascii 64) }
  {
    title: (string-ascii 100),
    description: (string-ascii 500),
    submitted-by: principal,
    submission-date: uint
  }
)

;; Public function to add a milestone
(define-public (add-milestone
    (project-id (string-ascii 64))
    (milestone-id (string-ascii 64))
    (title (string-ascii 100))
    (description (string-ascii 500))
    (due-date uint))
  (begin
    ;; Check if milestone already exists
    (asserts! (is-none (map-get? milestones { project-id: project-id, milestone-id: milestone-id })) (err u409))

    (ok (map-set milestones
      { project-id: project-id, milestone-id: milestone-id }
      {
        title: title,
        description: description,
        due-date: due-date,
        completed: false,
        completion-date: none
      }
    ))
  )
)

;; Public function to mark milestone as completed
(define-public (complete-milestone
    (project-id (string-ascii 64))
    (milestone-id (string-ascii 64)))
  (begin
    ;; Check if milestone exists
    (match (map-get? milestones { project-id: project-id, milestone-id: milestone-id })
      milestone (ok (map-set milestones
        { project-id: project-id, milestone-id: milestone-id }
        (merge milestone {
          completed: true,
          completion-date: (some block-height)
        })
      ))
      (err u404)
    )
  )
)

;; Public function to add a project update
(define-public (add-project-update
    (project-id (string-ascii 64))
    (update-id (string-ascii 64))
    (title (string-ascii 100))
    (description (string-ascii 500)))
  (begin
    ;; Check if update already exists
    (asserts! (is-none (map-get? project-updates { project-id: project-id, update-id: update-id })) (err u409))

    (ok (map-set project-updates
      { project-id: project-id, update-id: update-id }
      {
        title: title,
        description: description,
        submitted-by: tx-sender,
        submission-date: block-height
      }
    ))
  )
)

;; Read-only function to get milestone details
(define-read-only (get-milestone (project-id (string-ascii 64)) (milestone-id (string-ascii 64)))
  (map-get? milestones { project-id: project-id, milestone-id: milestone-id })
)

;; Read-only function to get project update
(define-read-only (get-project-update (project-id (string-ascii 64)) (update-id (string-ascii 64)))
  (map-get? project-updates { project-id: project-id, update-id: update-id })
)

;; Read-only function to check if milestone is completed
(define-read-only (is-milestone-completed (project-id (string-ascii 64)) (milestone-id (string-ascii 64)))
  (match (map-get? milestones { project-id: project-id, milestone-id: milestone-id })
    milestone (get completed milestone)
    false
  )
)
