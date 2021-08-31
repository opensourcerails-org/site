# frozen_string_literal: true

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }
  page_action :toggle_admin, method: :get do
    if cookies[:hide_admin]
      cookies.delete(:hide_admin)
    else
      cookies[:hide_admin] = { value: true, expires: 2.years.from_now }
    end
    redirect_to params[:return_to]
  end

  page_action :bookmarklet, method: :get do
    prj = Project.find_or_initialize_by(github: params[:github])
    return render plain: 'exists' if prj.persisted?

    prj.assign_attributes(name: params[:github], rails_major_version: 5)
    prj.save!
    render plain: prj.id
  end

  content do
    columns do
      column span: 2 do
        panel 'Visits' do
          Ahoy::Visit.where(started_at: Time.current.beginning_of_day..).count
        end
      end
      column span: 2 do
        panel 'Events' do
          Ahoy::Event.where(time: Time.current.beginning_of_day..).count
        end
      end
    end
    columns do
      column span: 2 do
        panel 'Top 10 landing pages today' do
          visits =  Ahoy::Visit.select('count(id) as total, landing_page').where(started_at: Time.current.beginning_of_day..).group(:landing_page).order('total desc').limit(10)
          table_for visits do
            column :total
            column :landing_page
          end
        end
      end

      column span: 2 do
        panel 'Events last 7 days' do
          things =  Ahoy::Event.select('count(id) as total, time::date as date').where(time: 7.days.ago.beginning_of_day..).group('time::date').order('date desc').limit(10)
          table_for things do
            column :date
            column :total
          end
        end
      end
    end
  end
end
