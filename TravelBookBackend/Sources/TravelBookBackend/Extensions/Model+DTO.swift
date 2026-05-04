import Foundation

extension Cell {
    func toDTO() -> CellDTO {
        CellDTO(id: self.id,
                image: self.image,
                type: self.category.type,
                title: self.title,
                subtitle: self.subtitle,
                date: self.date,
                readingTime: self.readingTime,
                description: self.description,
                images: self.images,
                isPopular: self.isPopular,
                isHeadCell: self.isHeadCell)
    }
}

extension Category {
    func toDTO() -> CategoryDTO {
        CategoryDTO(id: self.id,
                    title: self.title,
                    type: self.type,
                    image: self.image,
                    cells: self.cells.map { $0.toDTO() })
    }
}

extension User {
    func toDTO() -> UserDTO {
        UserDTO(id: self.id,
                name: self.name,
                email: self.email,
                dateRegistered: self.dateRegistered)
    }
}
