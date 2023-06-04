require "thread"

class MainpageController < ApplicationController
  skip_before_action :authenticate_user!
  def index
  end

  def download_pdf
    mutex = Mutex.new
    threads = []

    filename = "All_users.pdf"

    threads << Thread.new do
      Prawn::Document.generate(filename) do |pdf|
        pdf.font_families.update("Georgia" => {
          normal: Rails.root.join("app", "assets", "fonts", "NotoSansGeorgian-Regular.ttf"),
          bold: Rails.root.join("app", "assets", "fonts", "NotoSansGeorgian-Bold.ttf")
        })
        pdf.font("Georgia")

        pdf.move_down(10)
        pdf.text("Users Information", size: 14, style: :bold, align: :center)

        table_headers = [
          { content: "Info", width: 30 },
          { content: "Email", width: 170 },
          { content: "Encrypted password", width: 250 },
          { content: "Creation date", width: 100 }
        ]
        users = User.all
        users_data = users.map do |user|
          created_at = user.created_at.strftime('%Y-%m-%d')
          pass = user == current_user ? user.encrypted_password : "Private info"
          [
            { content: '', image: Rails.root.join("app", "assets", "images", "user_info.png"), fit: [20, 20] },
            user.email,
            pass,
            created_at[0, 10]
          ]
        end
        pdf.table([table_headers] + users_data, width: 550, cell_style: { borders: [], padding: [4, 2] })
      end

      mutex.synchronize do
        send_file(filename, filename: filename, type: "application/pdf")
      end
    end

    threads.each(&:join)
  end
end
