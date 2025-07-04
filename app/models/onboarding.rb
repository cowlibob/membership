class Onboarding < ApplicationRecord
  belongs_to :member

  validates :member_id, presence: true

  def google_group_complete?
    google_group_added_at.present?
  end

  def website_complete?
    website_added_at.present?
  end

  def whatsapp_invite_complete?
    whatsapp_invite_email_sent_at.present?
  end

  def management_email_complete?
    management_email_sent_at.present?
  end

  def timeline_steps
    [
      {
        name: 'Google Group',
        attempted_at: google_group_attempted_at,
        completed_at: google_group_added_at,
        complete: google_group_complete?
      },
      {
        name: 'Website Access',
        attempted_at: website_attempted_at,
        completed_at: website_added_at,
        complete: website_complete?
      },
      {
        name: 'WhatsApp Invite',
        attempted_at: nil,
        completed_at: whatsapp_invite_email_sent_at,
        complete: whatsapp_invite_complete?
      },
      {
        name: 'Management Notification',
        attempted_at: nil,
        completed_at: management_email_sent_at,
        complete: management_email_complete?
      }
    ]
  end

  def process_google_group
    update(google_group_attempted_at: Time.current, error_message: nil)
    
    begin
      # TODO: Implement actual Google Group API integration
      # For now, simulate processing with a delay and mark as complete
      sleep(2)
      update(google_group_added_at: Time.current)
      
      Rails.logger.info "Processed Google Group for member #{member.full_name}"
    rescue StandardError => e
      error_msg = "Failed to add to Google Group: #{e.message}"
      update(error_message: error_msg)
      Rails.logger.error "Google Group error for #{member.full_name}: #{e.message}"
      raise e
    end
  end

  def process_website_access
    update(website_attempted_at: Time.current, error_message: nil)
    
    begin
      # Create member in Ghost CMS
      ghost_response = create_ghost_member
      
      if ghost_response.code.to_i.between?(200, 299)
        update(website_added_at: Time.current)
        Rails.logger.info "Successfully created Ghost member for #{member.full_name}: #{ghost_response.body}"
      else
        error_msg = "Failed to create website account (HTTP #{ghost_response.code}): #{ghost_response.body}"
        update(error_message: error_msg)
        Rails.logger.error "Failed to create Ghost member for #{member.full_name} (#{ghost_response.code}): #{ghost_response.body}"
        raise "Ghost API error (#{ghost_response.code}): #{ghost_response.body}"
      end
    rescue StandardError => e
      error_msg = "Website access error: #{e.message}"
      update(error_message: error_msg)
      Rails.logger.error "Error creating Ghost member for #{member.full_name}: #{e.message}"
      raise e
    end
  end

  private

  def create_ghost_member
    require 'net/http'
    require 'json'
    require 'jwt'
    
    uri = URI("#{Rails.application.credentials.ghost[:api_url]}/ghost/api/admin/members/")
    
    # Prepare member data
    member_data = {
      members: [{
        email: member.email,
        name: member.full_name.present? ? member.full_name : nil
      }.compact]
    }
    
    # Create HTTP request
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'
    
    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = "Ghost #{generate_ghost_jwt}"
    request['Content-Type'] = 'application/json'
    request.body = member_data.to_json
    
    http.request(request)
  end

  def generate_ghost_jwt
    # Split the key into key_id and secret
    key_parts = Rails.application.credentials.ghost[:api_key].split(':')
    key_id = key_parts[0]
    key_secret = [key_parts[1]].pack('H*') # Convert hex to binary
    
    # Create JWT payload
    now = Time.current.to_i
    payload = {
      iat: now,
      exp: now + 300, # Token expires in 5 minutes
      aud: '/admin/'
    }
    
    # Generate JWT
    JWT.encode(payload, key_secret, 'HS256', { kid: key_id })
  end

  def process_whatsapp_invite
    update(error_message: nil)
    
    begin
      # TODO: Implement actual WhatsApp invitation email sending
      # For now, simulate sending invite email
      sleep(1)
      update(whatsapp_invite_email_sent_at: Time.current)
      
      Rails.logger.info "Sent WhatsApp invite to member #{member.full_name}"
    rescue StandardError => e
      error_msg = "Failed to send WhatsApp invite: #{e.message}"
      update(error_message: error_msg)
      Rails.logger.error "WhatsApp invite error for #{member.full_name}: #{e.message}"
      raise e
    end
  end

  def process_management_notification
    update(error_message: nil)
    
    begin
      # TODO: Implement actual management notification sending
      # For now, simulate sending notification
      sleep(1)
      update(management_email_sent_at: Time.current)
      
      Rails.logger.info "Sent management notification for member #{member.full_name}"
    rescue StandardError => e
      error_msg = "Failed to send management notification: #{e.message}"
      update(error_message: error_msg)
      Rails.logger.error "Management notification error for #{member.full_name}: #{e.message}"
      raise e
    end
  end
end
