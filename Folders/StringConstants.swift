//
//  StringConstants.swift
//  Folders
//
//  Created by Kerem Tuna Tomak on 8.09.2023.
//

import Foundation

enum StringConstants {
    static let DateTimeFormat = "yyyyMMdd-HHmmssSSS"
    static let DateFormat = "yyyyMMdd"
    static let Folders = "Folders"
    static let FolderName = "Folder Name"
    static let Videos = "Videos"
    static let SelectItems = "Select Items"
    static let Select = "Select"
    static let Cancel = "Cancel"
    
    enum SectionTitle {
        static let Pinned = "Pinned"
        static let Todays = "Todays"
        static let Session = "Session"
    }
    
    enum SystemImage {
        static let Plus = "plus"
        static let Heart = "heart"
        static let Trash = "trash"
        
    }
    
    
    enum Alert {
        enum ButtonText {
            static let Save = "Save"
            static let Cancel = "Cancel"
            static let Delete = "Delete"
        }
        enum Title {
            static let CreateFolder = "Create Folder"
            static let FolderName = "Folder Name"
            static let RenameFolder = "Rename Folder"
            static let Deleting = "Deleting!"
        }
        enum Message {
            static let DeleteConfirmationMessage = "Are you sure you want to delete the selected folders?"
        }
    }
    
    enum ContextMenu {
        case Pin
        case Unpin
        case AddFavorite
        case Rename
        case Delete
        
        var SystemImage: String {
            switch self {
            case .Pin:
                return "pin"
            case .Unpin:
                return "pin.slash"
            case .AddFavorite:
                return "heart"
            case .Rename:
                return "pencil"
            case .Delete:
                return "trash"
            }
        }
        
        var Text: String {
            switch self {
            case .Pin:
                return "Pin"
            case .Unpin:
                return "Unpin"
            case .AddFavorite:
                return "Add Favorite"
            case .Rename:
                return "Rename"
            case .Delete:
                return "Delete"
            }
        }
    }
}
