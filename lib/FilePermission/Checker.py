from stat import *
import os
import pwd
import grp


class PermissionParser:
    def __init__(self, string):
        flags = 0
        for letter in string:
            if letter == 'r':
                flags |= S_IRUSR | S_IRGRP | S_IROTH
            if letter == 'w':
                flags |= S_IWUSR | S_IWGRP | S_IWOTH
            if letter == 'x':
                flags |= S_IXUSR | S_IXGRP | S_IXOTH
        self.flags = flags

    def for_user(self):
        return self.flags & S_IRWXU

    def for_group(self):
        return self.flags & S_IRWXG

    def for_others(self):
        return self.flags & S_IRWXO


class PermissionReader:
    def __init__(self, path, permissions_needed):
        self.stat = os.stat(path)
        self.permissions = permissions_needed

    def is_owner(self, username):
        return pwd.getpwuid(self.stat.st_uid).pw_name == username

    def is_group(self, username):
        return grp.getgrgid(self.stat.st_gid).gr_name == username

    def has_permissions(self, username):
        try:
            if pwd.getpwnam(username).pw_uid == 0:
                return True
        except KeyError:
            pass
        if self.is_owner(username):
            return self.check_values(self.permissions.for_user())
        if self.is_group(username):
            return self.check_values(self.permissions.for_group())
        return self.check_values(self.permissions.for_others())

    def check_values(self, permission):
        return permission & self.stat.st_mode == permission
