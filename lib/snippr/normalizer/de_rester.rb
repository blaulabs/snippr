# = Snippr::Normalizer::DeRester
#
# "Redirects" REST path elements that are accessed via POST (create, update destroy) with
# their corresponding GET elements (new, edit, show) so that when eg create is rendered due
# to an error in the action, it just looks exactly like the new page it was issued from.
module Snippr

  module Normalizer

    class DeRester

      def normalize(path_element)
        case path_element.to_s
        when "create" then "new"
        when "update" then "edit"
        when "destroy" then "show"
        else path_element.to_s
        end
      end

    end

  end

end
