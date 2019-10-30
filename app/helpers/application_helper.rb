# frozen_string_literal: true

module ApplicationHelper

  def time_zone_collection
    ActiveSupport::TimeZone.all.map { |tz| [tz.name, tz.name] }
  end

  def recording_file_from_uri(uri)
    base = uri.split(".").first
    "https://api.twilio.com/#{base}.wav"
  end

  def email(mail, label = nil)
    label ||= mail
    link_to(label, "mailto:#{mail}")
  end

  def number_in_cents_to_currency(number, options = {})
    number_to_currency(number / 100, options)
  end

  def formatted_date(date)
    date.strftime("%-m/%e/%y %l:%M %p")
  end

  def render_flash(locals = {})
    unless @flash_rendered
      @flash_rendered = true
      return render "layouts/flash", locals: locals
    end
    ""
  end

  def card_with_last4(card_brand, last4)
    if card_brand == "amex"
      "•••• •••••• •#{last4}"
    else
      "•••• •••• •••• #{last4}"
    end
  end

  def card_exp(mo, yr)
    [mo.to_s.rjust(2, "0"), yr.to_s].join("/")
  end

  def parent_layout(layout)
    @view_flow.set(:layout, output_buffer)
    output = render(file: "layouts/#{layout}")
    self.output_buffer = ActionView::OutputBuffer.new(output)
  end

  def class_if(klass, *matches)
    matches.each do |match|
      if match.ends_with?("*")
        return klass if match == "#{params[:controller]}#*"
      else
        return klass if match == "#{params[:controller]}##{params[:action]}"
      end
    end
    ""
  end

  def page_title
    if @title.present?
      "#{@title} - "
    else
      ""
    end.concat("PassTheMicrophone")
  end

  def format_flash_message(message)
    raw message.gsub("href=", 'class="alert-link" href=')
  end

  def flash_class
    { notice: "info", error: "danger", success: "success", alert: "danger" }.with_indifferent_access
  end

  def interview_mindate
    d = Date.today
    "#{d.year}/#{d.month}/#{d.day}"
  end

   def interview_maxdate
    d = 3.months.from_now.to_date
    "#{d.year}/#{d.month}/#{d.day}"
   end

   def invite_address_last_line(invite)
     addy = ""
     if !invite.city.blank? && !invite.state.blank?
      addy = "#{invite.city}, #{invite.state}"
     end
     if !invite.zip_code.blank?
       addy = addy + "  #{invite.zip_code}"
     end
     addy
   end

   def interview_title(interview)
    if interview.starts_at.present?
      raw("Interview on #{local_time(interview.starts_at)}")
    else
      'Unscheduled interview'
    end
   end

  def ga_js
    return %Q{
      <!-- Global site tag (gtag.js) - Google Analytics -->
      <script async src="https://www.googletagmanager.com/gtag/js?id=UA-130414843-1"></script>
      <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());

        gtag('config', 'UA-130414843-1');
      </script>
    }.html_safe
  end

  def help_desk_js
    return %Q{
      <!-- Help Desk Code -->
      <script type="text/javascript" > window.ZohoHCAsap=window.ZohoHCAsap||function(a,b){ZohoHCAsap[a]=b;};(function(){var d=document; var s=d.createElement("script");s.type="text/javascript";s.defer=true; s.src="https://desk.zoho.com/portal/api/web/inapp/331449000000226009?orgId=677679421"; d.getElementsByTagName("head")[0].appendChild(s); })(); </script>
      <!-- End Help Desk Code -->    
    }.html_safe
  end

  def customer_support_js
    return %Q{
      <!-- Customer Support Code -->
      <script type="text/javascript">var $zoho=$zoho || {};$zoho.salesiq = $zoho.salesiq || {widgetcode:"3696b68de0cacd63bcf9d312907e47d6285b04dc55e4e295ee3c722679b3ae753035dc12603a7849bb760614d45fddab", values:{},ready:function(){}};var d=document;s=d.createElement("script");s.type="text/javascript";s.id="zsiqscript";s.defer=true;s.src="https://salesiq.zoho.com/widget";t=d.getElementsByTagName("script")[0];t.parentNode.insertBefore(s,t);d.write("<div id='zsiqwidget'></div>");</script>
      <!-- End Customer Support Code -->    
    }.html_safe
  end

  def hide_support_help_widgets?
    return true if request.path == '/users/sign_up'
    false
  end

  def darken?(name_to_check)
   (controller_name == name_to_check) ? 'list-group-item-darker' : ''
  end

  def url_for_bundle(bundle)
    checkout_path(bundle_id: bundle.id)
  end

  def datetime_readable(dtime)
    if [ActiveSupport::TimeWithZone, DateTime].include?(dtime.class)
      dtime.strftime("%m/%d/%Y at %I:%M %p %Z")
    elsif dtime.is_a?(Date)
      dtime.strftime("%m/%d/%Y")
    else
      dtime
    end
  end

  def within_twelve_hours?(a_datetime)
    return true if a_datetime.nil?
    return false if (a_datetime.utc < 12.hours.ago)
    DateTime.now.utc < 12.hours.from_now.utc
  end

end
