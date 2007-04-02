class Email < ActionMailer::Base
  def new_key(function, organisation)
    # Email header info MUST be added here
    recipients function.email
    from organisation.email
    subject 'Link to EINA'
    # Email body substitutions go here
    body :subdomain => organisation.style, :key => function.key
  end
end
