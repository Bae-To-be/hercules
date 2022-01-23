class UnreadMigration < Unread::MIGRATION_BASE_CLASS
  def self.up
    safety_assured do
      create_table ReadMark, force: true do |t|
        t.references :readable, type: :uuid,  polymorphic: { null: false }
        t.references :reader, polymorphic: { null: false }
        t.datetime :timestamp
      end

      add_index ReadMark, [:reader_id, :reader_type, :readable_type, :readable_id], name: 'read_marks_reader_readable_index', unique: true
    end
  end

  def self.down
    safety_assured { drop_table ReadMark }
  end
end
